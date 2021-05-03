require "kemal"
require "db"
require "pg"
require "json"
require "./user.cr"
require "./queries.cr"


module MapTogether::Server

	module Endpoints
		address = "postgres://maptogether:maptogether@localhost:5432/maptogether?retry_attempts=100"

		# Request data about a specific user (id, name, score, achievements and followers)
		get "/user/:id" do |env|
			user = User.new
			id = env.params.url["id"]
			DB.connect address do |db|
				user.user_id, user.name = db.query_one Queries::USER_FROM_ID, id, as: {Int32, String}
				user.score = db.query_one Queries::TOTAL_SCORE_FROM_ID, id, as: {Int64}

				user.achievements = [] of String
				db.query Queries::ACHIEVEMENTS_FROM_ID, id do |rows|
					rows.each do
						user.achievements << rows.read(String)
					end
				end

				user.followers = [] of User
				db.query Queries::FOLLOWERS_FROM_ID, id do |rows|
					rows.each do
						user.followers << User.new(user_id: rows.read(Int32), name: rows.read(String))
					end
				end

				user.following = [] of User
				db.query Queries::FOLLOWING_FROM_ID, id do |rows|
					rows.each do
						user.following << User.new(user_id: rows.read(Int32), name: rows.read(String))
					end
				end
			end

			JSON.build do |json|
				user.to_json(json)
			end
		end

		# Retrieve all users' id, name and score
		get "/leaderboard/global/all_time" do |env|
			JSON.build do |json|
				json.object do
					DB.connect address do |db|
						db.query Queries::TOTAL_LEADERBOARD do |rows|
							json.field "users" do
								json.array do
									rows.each do
										User.new(user_id: rows.read(Int32), name: rows.read(String), score: rows.read(Int64)).to_json(json)
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

