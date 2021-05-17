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
        		db.query Queries::USER_UPSERT, id, name, key
    		end
    		
    		id
		end
		
		# Request data about a specific user (id, name, score, achievements and followers)
		get "/user/:id" do |env|
			user = User.new
			id = env.params.url["id"]
			#access = env.request.headers["Authorization"]
			#puts "Access: #{access}"
			
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

			
			env.response.content_type = "application/json"
			JSON.build do |json|
				user.to_json(json)
			end
		end
		
		put "/user/:id/following/:followee" do |env|
			id = env.params.url["id"]
			followee = env.params.url["followee"]
			
			try_open_connection do |db|
				db.exec "INSERT INTO follows (follower, followee) VALUES ($1, $2)", id, followee
			end
		end

		delete "/user/:id/following/:followee" do |env|
			id = env.params.url["id"]
			followee = env.params.url["followee"]

			try_open_connection do |db|
				result = db.exec "DELETE FROM follows WHERE follower = $1 AND followee = $2", id, followee
				raise "Error! deleted #{result.rows_affected} rows" if result.rows_affected != 1
			end
		end

		put "/user/:id/:name" do |env|
			id = env.params.url["id"]
			name = env.params.url["name"]

			try_open_connection do |db|
				db.exec "INSERT INTO users (userID, name) VALUES ($1, $2)", id, name
			end
		end
		
		# Retrieve all users' id, name and score
		get "/leaderboard/global/all_time" do |env|
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

		get "/leaderboard/global/monthly" do |env|
			string = JSON.build do |json|
				try_open_connection do |db|
					db.query Queries::GLOBAL_INTERVAL, Time.utc.at_beginning_of_month, Time.utc.at_end_of_month do |rows|
    					Leaderboard.new(rows).to_json json
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

