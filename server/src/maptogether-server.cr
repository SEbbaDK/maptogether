require "kemal"
require "db"
require "pg"
require "json"
require "./user.cr"
require "./scoring.cr"
require "./queries.cr"
require "./achievement.cr"
require "./contribution.cr"


module MapTogether::Server

	module Endpoints
		extend self
		address = "postgres://maptogether:maptogether@localhost:5432/maptogether?retry_attempts=100"

		def leaderboard_to_json(json_builder json : JSON::Builder, rows)
			json.array do
				rows.each do
					Scoring.new(
						user: User.new(
							user_id: rows.read(Int64),
							name: rows.read(String)
						),
						score: rows.read(Int64)
					).to_json(json)
				end
			end
		end

		def try_open_connection(&block)
			begin
				yield DB.open "postgres://maptogether:maptogether@localhost:5432/maptogether?retry_attempts=100"
			rescue exception : DB::ConnectionRefused
				raise DB::ConnectionRefused.new("Could not connect to database")
			end
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
			end

			put "/user/:id/following/:followee" do |env|
				id = env.params.url["id"]
				followee = env.params.url["followee"]
				
				# TODO: Does this throw a nice error if the user does not exist? else make some check
				try_open_connection do |db|
					#db.query_one Queries::USER_FROM_ID, id, as: {Int64, String}
					db.exec "INSERT INTO follows (follower, followee) VALUES ($1, $2)", id, followee
				end
			end

			delete "user/:id/following/:followee" do |env|
				id = env.params.url["id"]
				followee = env.params.url["followee"]

				try_open_connection do |db|
					# TODO: Does this throw a nice error if the follows does not exist? else make some check
					#db.query_one "SELECT follower, followee FROM follows WHERE follower = $1 AND followee = $2", id, followee as: {Int64, Int64}
					result = db.exec "DELETE FROM follows WHERE follower = $1 AND followee = $2", id, followee
					raise "Oops deleted ${result.rows_affected} rows" if result.rows_affected != 1
				end
			end

			put "/user/:id/:name" do |env|
				id = env.params.url["id"]
				name = env.params.url["name"]

				try_open_connection do |db|
					db.exec "INSERT INTO users (userID, name) VALUES ($1, $2)", id, name
				end
			end

			env.response.content_type = "application/json"
			JSON.build do |json|
				user.to_json(json)
			end
		end

		# Retrieve all users' id, name and score
		get "/leaderboard/global/all_time" do |env|
			string = JSON.build do |json|
				try_open_connection do |db|
					db.query Queries::GLOBAL_ALL_TIME do |rows|
						Endpoints.leaderboard_to_json(json, rows)
					end
				end
			end

			env.response.content_type = "application/json"
			string
		end

		get "/leaderboard/global/monthly" do |env|
			string = JSON.build do |json|
				try_open_connection do |db|
					db.query Queries::GLOBAL_INTERVAL, Time.utc.at_beginning_of_month, Time.utc.at_end_of_month do |rows|
						Endpoints.leaderboard_to_json(json, rows)
					end
				end
			end

			env.response.content_type = "application/json"
			string
		end

		get "/leaderboard/global/weekly" do |env|
			string = JSON.build do |json|
				try_open_connection do |db|
					db.query Queries::GLOBAL_INTERVAL, Time.utc.at_beginning_of_week, Time.utc.at_end_of_week do |rows|
						Endpoints.leaderboard_to_json(json, rows)
					end
				end
			end

			env.response.content_type = "application/json"
			string
		end

		post "/contribution" do |env|
			contribution = Contribution.from_json(env.params.json)
	        try_open_connection do |db|
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
			env.response.content_type = "application/json"
			"hi"
		end

		error 500 do |env, exc|
			"Something went wrong, \"#{exc.class}\" was thrown with message: \"#{exc.message}\""
		end
	
		error 404 do
			"404 Path not defined"
		end
	end

	port = (ENV["KEMAL_PORT"]? || 8080).to_i32
	Kemal.run port
end

