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
require "./leaderboard-summary.cr"
require "./types.cr"

module MapTogether::Server
	POOL = DB.open "postgres://maptogether:maptogether@localhost:5432/maptogether?retry_attempts=100&max_pool_size=950&checkout_timeout=20.0"

	macro http_raise(status, message)
		halt env, status_code: {{status}}, response: {{message}}
	end

	macro check_auth(id, env, db)
		%id = {{id}}.to_i64
		%auth_head = {{env}}.request.headers["Authorization"]?
		http_raise 400, "Authentication header is missing" if %auth_head == nil
		
		%auth = %auth_head.as(String).split(" ")
		http_raise 400, "Authentication header needs to be 'Basic <ACCESS_KEY>'" if %auth.size != 2

		%atype, %key = %auth
		http_raise 400, "Authentication type needs to be 'Basic'" if %atype != "Basic"
		
		%aid = {{db}}.query_one? "SELECT userid FROM users WHERE access = $1", %key, as: Int64
		http_raise 401, "User #{%id} does not have the given access token" if %aid.nil?
		http_raise 401, "Authenticated user does not have permission for this (#{%id} != #{%aid}" if %id != %aid
	end

	put "/user/:id" do |env|
		id = env.params.url["id"].to_i64

		vals = env.request.headers["Authorization"].split(" ")
		http_raise 400, "Both access and client keypairs are required" if vals.size < 5
		atype, key, secret, ckey, csecret = vals
		http_raise 400, "Authentication type needs to be 'Basic'" if atype != "Basic"

		# TODO: It is important that we add this check back in, but oauth seems to be broken
		# with osm, so it is disabled for now

		# client = HTTP::Client.new "master.apis.dev.openstreetmap.org", tls: true
		# OAuth.authenticate client, key, secret, ckey, csecret

		# response = client.get("/api/0.6/user/details.json")
		# puts vals if response.status_code != 200
		# puts "Body: #{response.body}" if response.status_code != 200
		# http_raise 401, "Authentication failed for OSM" if response.status_code == 401
		# http_raise 500, "Something went wrong with OSM login: #{response.status_code} #{response.body}" if response.status_code != 200
		# json = JSON.parse(response.body)
		# osm_id = json["user"]["id"].as_i64
		# name = json["user"]["display_name"]

		# TEMP
		name = "User #{id}"
		# TEMP

		# http_raise 400, "Id: #{id} does not match the OSM id of #{osm_id}" if id != osm_id

		POOL.using_connection do |db|
			puts "Upserting user"
			db.exec Queries::USER_UPSERT, id, name, key

			puts "Refreshing views"
			db.exec "REFRESH MATERIALIZED VIEW leaderboardAllTime"
			db.exec "REFRESH MATERIALIZED VIEW leaderboardMonthly"
			db.exec "REFRESH MATERIALIZED VIEW leaderboardWeekly"
		end

		id
	end

	# Request data about a specific user (id, name, score, achievements and followers)
	get "/user/:id" do |env|
		user = User.new
		id = env.params.url["id"].to_i64

		POOL.using_connection do |db|
			puts "USER_FROM_ID"
			user.user_id, user.name = db.query_one Queries::USER_FROM_ID, id, as: {Int64, String}
			puts "SCORE_FROM_ID"
			user.score_all_time =
				db.query_one Queries.score_from_id(LeaderboardType::AllTime), id, as: {Int64}
			puts "SCORE_FROM_ID"
			user.score_monthly =
				db.query_one Queries.score_from_id(LeaderboardType::Monthly), id, as: {Int64}
			puts "SCORE_FROM_ID"
			user.score_weekly =
				db.query_one Queries.score_from_id(LeaderboardType::Weekly), id, as: {Int64}

			achievements = [] of Achievement
			puts "ACHIEVEMENTS_FROM_ID"
			db.query Queries::ACHIEVEMENTS_FROM_ID, id do |rows|
				rows.each do
					achievements << Achievement.new(rows.read(String), rows.read(String))
				end
			end
			user.achievements = achievements

			followers = [] of User
			puts "FOLLOWERS_FROM_ID"
			db.query Queries::FOLLOWERS_FROM_ID, id do |rows|
				rows.each do
					followers << User.new(user_id: rows.read(Int64), name: rows.read(String))
				end
			end
			user.followers = followers

			following = [] of User
			puts "FOLLOWING_FROM_ID"
			db.query Queries::FOLLOWING_FROM_ID, id do |rows|
				rows.each do
					following << User.new(user_id: rows.read(Int64), name: rows.read(String))
				end
			end
			user.following = following

			user.leaderboards = [] of LeaderboardSummary
			RankType.each do |r|
				LeaderboardType.each do |l|
					rank, count = db.query_one Queries.rank_and_count(r, l), id, as: {Int64, Int64}
					user.leaderboards.try &.<< LeaderboardSummary.new id, r, l, rank, count
				end
			end
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

		POOL.using_connection do |db|
			check_auth(id, env, db)
			db.exec "INSERT INTO follows (follower, followee) VALUES ($1, $2)", id, followee
		end
	end

	delete "/user/:id/following/:followee" do |env|
		id = env.params.url["id"]
		followee = env.params.url["followee"]

		POOL.using_connection do |db|
			check_auth(id, env, db)
			result = db.exec "DELETE FROM follows WHERE follower = $1 AND followee = $2", id, followee
			http_raise 400, "User not following that user" if result.rows_affected == 0
			raise "Error! deleted #{result.rows_affected} rows" if result.rows_affected != 1
		end
	end

	get "/leaderboard/:time/personal/:id" do |env|
		time = LeaderboardType.from_s env.params.url["time"]
		id = env.params.url["id"]

		string = JSON.build do |json|
			POOL.using_connection do |db|
				db.query Queries.leaderboard(RankType::Personal, time), id do |rows|
					Leaderboard.new(rows).to_json json
				end
			end
		end

		env.response.content_type = "application/json"
		string
	end

	# Retrieve all users' id, name and score
	get "/leaderboard/:time/global" do |env|
		time = LeaderboardType.from_s env.params.url["time"]

		string = JSON.build do |json|
			POOL.using_connection do |db|
				db.query Queries.leaderboard(RankType::Global, time) do |rows|
					Leaderboard.new(rows).to_json json
				end
			end
		end

		env.response.content_type = "application/json"
		string
	end

	post "/contribution" do |env|
		contribution = Contribution.from_json(env.params.json)
		POOL.using_connection do |db|
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
	port = (ARGV[0]? || 3000).to_i32
	Kemal.run port
	POOL.close
end
