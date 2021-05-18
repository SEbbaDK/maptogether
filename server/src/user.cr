require "./achievement.cr"

class User
	property user_id : Nil | Int64
	property name : Nil | String
	property score : Nil | Int64
	property achievements : Array(Achievement)
	property followers : Array(User)
	property following : Array(User)

	def initialize(
		@user_id = nil,
		@name = nil,
		@score = nil,
		@achievements = [] of Achievement,
		@followers = [] of User,
		@following = [] of User
	)
	end

	def to_json(json : JSON::Builder)
		json.object do
			json.field "id", @user_id
			json.field "name", @name
			json.field "score", @score unless @score.nil?

			json.field "achievements" do
				json.array do
					@achievements.each do |achievement|
						achievement.to_json(json)
					end
				end
			end unless @achievements.size == 0

			json.field "followers" do
				json.array do
					@followers.each do |follower|
						follower.to_json(json)
					end
				end
			end unless @followers.size == 0

			json.field "following" do
				json.array do
					@following.each do |followee|
						followee.to_json(json)
					end
				end
			end unless @following.size == 0
		end
	end
end
