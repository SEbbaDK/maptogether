require "./achievement.cr"
require "./placement.cr"

class User
	property user_id : Nil | Int64
	property name : Nil | String
	property score : Nil | Int64
	property achievements : Nil | Array(Achievement)
	property followers : Nil | Array(User)
	property following : Nil | Array(User)
	property leaderboards : Nil | Array(Placement)

	def initialize(
		@user_id = nil,
		@name = nil,
		@score = nil,
		@achievements = nil,
		@followers = nil,
		@following = nil,
		@leaderboards = nil
	)
	end

	def to_json(json : JSON::Builder)
		json.object do
			json.field "id", @user_id
			json.field "name", @name
			json.field "score", @score unless @score.nil?

			json.field "achievements" do
				json.array do
					@achievements.try &.each &.to_json(json)
				end
			end unless @achievements.nil?

			json.field "followers" do
				json.array do
					@followers.try &.each &.to_json(json)
				end
			end unless @followers.nil?

			json.field "following" do
				json.array do
					@following.try &.each &.to_json(json)
				end
			end unless @following.nil?

			json.field "leaderboards" do
				json.array do
					@leaderboards.try &.each &.to_json(json)
				end
			end unless @leaderboards.nil?
		end
	end
end
