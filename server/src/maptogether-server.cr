require "kemal"
require "db"
require "pg"
require "json"
require "./user.cr"


module MapTogether::Server

	module Endpoints
		address = "postgres://maptogether:maptogether@localhost:5432/maptogether?retry_attempts=100"

		# Request data about a specific user (id, name, score, achievements and followers)
		get "/user/:id" do |env|
			user = User.new
			id = env.params.url["id"]
			DB.connect address do |db|
				user.userID, user.name = db.query_one "SELECT userID, name FROM users WHERE userID = $1 limit 1", id, as: {Int32, String}
				user.score = db.query_one "SELECT SUM (score) AS score FROM contributions WHERE userID = $1", id, as: {Int32}
				
				user.achievements = [] of String
				db.query "SELECT achievement FROM unlocked WHERE userID = $1", id do |rows|
					rows.each do
						user.achievements << rows.read(String)
					end
				end

				user.followers = [] of User
				db.query "SELECT userID, name FROM follows INNER JOIN users ON follower = userID WHERE followee = $1", id do |rows|
					rows.each do
						user.followers << User.new(userID: rows.read(Int32), name: rows.read(String))
					end
				end

				user.following = [] of User
				db.query "SELECT userID, name FROM follows INNER JOIN users ON followee = userID WHERE follower = $1", id do |rows|
					rows.each do
						user.following << User.new(userID: rows.read(Int32), name: rows.read(String))
					end
				end
			end

			JSON.build do |json|
				user.toJson(json)
			end
		end

		# Retrieve all users' id, name and score
		get "/leaderboard/global/all_time" do |env|
			JSON.build do |json|
				json.object do
					DB.connect address do |db|
						db.query "SELECT userID, name, score FROM (SELECT userID, SUM (score) AS score FROM contributions GROUP BY userID) AS s INNER JOIN users AS u ON u.userID = s.userID ORDER BY score DESC" do |rows|
							json.field "users" do
								rows.each do
									json.array do
										User.new(userID: rows.read(Int32), name: rows.read(String), score: rows.read(Int32)).toJson(json)
									end
								end
							end
						end
					end
				end
			end
		end
		
		# Test endpoint
		get "/" do
			"hi"
		end
	end


	Kemal.run 8080
end

