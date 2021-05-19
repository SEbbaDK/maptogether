require "kemal"
require "db"
require "pg"
require "json"
require "oauth"
require "./user.cr"
require "./leaderboard.cr"
require "./queries.cr"
require "./achievement.cr"
require "./contribution.cr"
require "./placement.cr"

module MapTogether::Server
	module Endpoints
		extend self
		address = "postgres://maptogether:maptogether@localhost:5432/maptogether?retry_attempts=100"

		def try_open_connection(&block)
			begin
				yield DB.open "postgres://maptogether:maptogether@localhost:5432/maptogether?retry_attempts=100"
			rescue exception : DB::ConnectionRefused
				raise DB::ConnectionRefused.new("Could not connect to database")
			end
		end

		macro http_raise(status, message)
			halt env, status_code: {{status}}, response: {{message}}
		end

		macro check_auth(id, env, db)
				%auth_head = {{env}}.request.headers["Authorization"]?
				http_raise 400, "Authentication header is missing" if %auth_head == nil
				
				%auth = %auth_head.as(String).split(" ")
			http_raise 400, "Authentication header needs to be 'Basic <ACCESS_KEY>'" if %auth.size != 2
			
			%atype, %key = %auth
			http_raise 400, "Authentication type needs to be 'Basic'" if %atype != "Basic"
			
			%aid = {{db}}.query_one "SELECT userid FROM users WHERE access = $1", %key, as: Int64
			http_raise 401, "Authenticated user does not have permission for this (#{{{id}}} != #{%aid}" if {{id}} != %aid
		end

		put "/user/:id" do |env|
			id = env.params.url["id"].to_i64

			vals = env.request.headers["Authorization"].split(" ")
			http_raise 400, "Both access and client keypairs are required" if vals.size < 5
			atype, key, secret, ckey, csecret = vals
			http_raise 400, "Authentication type needs to be 'Basic'" if atype != "Basic"

			client = HTTP::Client.new "master.apis.dev.openstreetmap.org", tls: true
			OAuth.authenticate client, key, secret, ckey, csecret

			response = client.get("/api/0.6/user/details.json")
			http_raise 401, "Authentication failed for OSM" if response.status_code == 401
			http_raise 500, "Something went wrong with OSM login: #{response.status_code} #{response.body}" if response.status_code != 200
			json = JSON.parse(response.body)
			osm_id = json["user"]["id"].as_i64
			name = json["user"]["display_name"]

			http_raise 400, "Id: #{id} does not match the OSM id of #{osm_id}" if id != osm_id

			try_open_connection do |db|
				db.exec Queries::USER_UPSERT, id, name, key
			end

			id
		end

		# Request data about a specific user (id, name, score, achievements and followers)
		get "/user/:id" do |env|
			user = User.new
			id = env.params.url["id"]

			try_open_connection do |db|
				user.user_id, user.name = db.query_one Queries::USER_FROM_ID, id, as: {Int64, String}
				user.score = db.query_one Queries::TOTAL_SCORE_FROM_ID, id, as: {Int64}

				user.achievements = [] of Achievement
				db.query Queries::ACHIEVEMENTS_FROM_ID, id do |rows|
					rows.each do
						user.achievements << Achievement.new(rows.read(String), rows.read(String))
					end
				end

				user.followers = [] of User
				db.query Queries::FOLLOWERS_FROM_ID, id do |rows|
					rows.each do
						user.followers << User.new(user_id: rows.read(Int64), name: rows.read(String))
					end
				end

				user.following = [] of User
				db.query Queries::FOLLOWING_FROM_ID, id do |rows|
					rows.each do
						user.following << User.new(user_id: rows.read(Int64), name: rows.read(String))
					end
				end

				user.leaderboards = [
					Placement.new(
						"Global",
						Leaderboard_Type::All_Time,
						db.query_one Queries::GLOBAL_ALL_TIME_RANK, as:{Int64},
						db.query_one Queries::GLOBAL_ALL_TIME_TOTAL
					),
					Placement.new(
						"Global",
						Leaderboard_Type::Monthly,
						db.query_one Queries::GLOBAL_MONTHLY_RANK, as:{Int64},
						db.query_one Queries::GLOBAL_MONTHLY_TOTAL
					),
					Placement.new(
						"Global",
						Leaderboard_Type::Weekly,
						db.query_one Queries::GLOBAL_WEEKLY_RANK, as:{Int64},
						db.query_one Queries::GLOBAL_WEEKLY_TOTAL
					),
					Placement.new(
						"Personal",
						Leaderboard_Type::All_Time,
						db.query_one Queries::PERSONAL_ALL_TIME_RANK, as:{Int64},
						db.query_one Queries::PERSONAL_ALL_TIME_TOTAL
					),
					Placement.new(
						"Personal",
						Leaderboard_Type::Monthly,
						db.query_one Queries::PERSONAL_MONTHLY_RANK, as:{Int64},
						db.query_one Queries::PERSONAL_MONTHLY_TOTAL
					),
					Placement.new(
						"Personal",
						Leaderboard_Type::Weekly,
						db.query_one Queries::PERSONAL_WEEKLY_RANK, as:{Int64},
						db.query_one Queries::PERSONAL_WEEKLY_TOTAL
					)
				]
			end

			env.response.content_type = "application/json"
			JSON.build do |json|
				user.to_json(json)
			end
		end

		put "/user/:id/following/:followee" do |env|
			id = env.params.url["id"]
			followee = env.params.url["followee"]
			http_raise 400, "User can't follow themselves" if id == followee

			try_open_connection do |db|
				check_auth(id, env, db)
				db.exec "INSERT INTO follows (follower, followee) VALUES ($1, $2)", id, followee
			end
		end

		delete "/user/:id/following/:followee" do |env|
			id = env.params.url["id"]
			followee = env.params.url["followee"]

			try_open_connection do |db|
				check_auth(id, env, db)
				result = db.exec "DELETE FROM follows WHERE follower = $1 AND followee = $2", id, followee
				http_raise 400, "User not following that user" if result.rows_affected == 0
				raise "Error! deleted #{result.rows_affected} rows" if result.rows_affected >= 1
			end
		end

		
		get "/leaderboard/all_time/personal/:id" do |env|
			id = env.params.url["id"]
			
			string = JSON.build do |json|
				try_open_connection do |db|
					check_auth(id, env, db)
					db.query Queries::PERSONAL_ALL_TIME, id do |rows|
						Leaderboard.new(rows).to_json json
					end
				end
			end
			
			env.response.content_type = "application/json"
			string
		end
		
		get "/leaderboard/weekly/personal/:id" do |env|
			id = env.params.url["id"]
			
			string = JSON.build do |json|
				try_open_connection do |db|
					check_auth(id, env, db)
					db.query Queries::PERSONAL_WEEKLY, id do |rows|
						Leaderboard.new(rows).to_json json
					end
				end
			end
			
			env.response.content_type = "application/json"
			string
		end
		
		get "/leaderboard/monthly/personal/:id" do |env|
			id = env.params.url["id"]
			
			string = JSON.build do |json|
				try_open_connection do |db|
					check_auth(id, env, db)
					db.query Queries::PERSONAL_MONTHLY, id do |rows|
						Leaderboard.new(rows).to_json json
					end
				end
			end
			
			env.response.content_type = "application/json"
			string
		end
		
		# Retrieve all users' id, name and score
		get "/leaderboard/all_time/global" do |env|
			string = JSON.build do |json|
				try_open_connection do |db|
					db.query Queries::GLOBAL_ALL_TIME do |rows|
						Leaderboard.new(rows).to_json json
					end
				end
			end

			env.response.content_type = "application/json"
			string
		end
		
		get "/leaderboard/monthly/global" do |env|
			string = JSON.build do |json|
				try_open_connection do |db|
					db.query Queries::GLOBAL_MONTHLY do |rows|
						Leaderboard.new(rows).to_json json
					end
				end
			end
			
			env.response.content_type = "application/json"
			string
		end

		get "/leaderboard/weekly/global" do |env|
			string = JSON.build do |json|
				try_open_connection do |db|
					db.query Queries::GLOBAL_WEEKLY do |rows|
						Leaderboard.new(rows).to_json json
					end
				end
			end

			env.response.content_type = "application/json"
			string
		end

		post "/contribution" do |env|
			contribution = Contribution.from_json(env.params.json)
			try_open_connection do |db|
				check_auth(contribution.user_id, env, db)
				db.exec "INSERT INTO contributions (userID, type, changeset, score, dateTime)
					VALUES ($1, $2, $3, $4, $5)",
					contribution.user_id,
					contribution.type,
					contribution.changeset,
					contribution.score,
					contribution.date_time
			end
		end

		# Test endpoint
		get "/" do |env|
			env.response.content_type = "text/html"
			"hi"
		end

		error 500 do |env, exc|
			"Something went wrong, \"#{exc.class}\" was thrown with message: \"#{exc.message}\""
		end

		error 404 do
			"404 Path not defined"
		end
	end

	port = (ARGV[0]? || 3000).to_i32
	Kemal.run port
end
