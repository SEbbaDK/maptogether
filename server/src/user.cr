require "./achievement.cr"
require "./leaderboard-summary.cr"

class User
	property user_id : Nil | Int64
	property name : Nil | String
	property score_all_time : Nil | Int64
	property score_monthly : Nil | Int64
	property score_weekly : Nil | Int64
	property achievements : Nil | Array(Achievement)
	property followers : Nil | Array(User)
	property following : Nil | Array(User)
	property leaderboards : Nil | Array(LeaderboardSummary)

	def initialize(
		@user_id = nil,
		@name = nil,
		@score_all_time = nil,
		@score_monthly = nil,
		@score_weekly = nil,
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
			json.field "score_all_time", @score_all_time unless @score_all_time.nil?
			json.field "score_monthly", @score_monthly unless @score_monthly.nil?
			json.field "score_weekly", @score_weekly unless @score_weekly.nil?

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
