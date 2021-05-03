class User
	property user_id : Nil | Int32
	property score : Nil | Int64
	property name : Nil | String
	property achievements : Array(String)
	property followers : Array(User)
	property following : Array(User)

	def initialize (
			@user_id = nil,
			@score = nil,
			@name = nil,
			@achievements = [] of String,
			@followers = [] of User,
			@following = [] of User
		)
	end

	def to_json (json_builder json : JSON::Builder)
		json.object do
			json.field "id", user_id unless user_id.nil?
			json.field "score", @score unless score.nil?
			json.field "name", name unless name.nil?

			ach = achievements
			json.field "achievements" do
				json.array do
					ach.each do |achievement|
						json.string achievement
					end
				end
			end

			fol = followers
			json.field "followers" do
				json.array do
					fol.each do |follower|
						follower.to_json(json)
					end
				end
			end

			foling = following
			json.field "following" do
				json.array do
					foling.each do |followee|
						followee.to_json(json)
					end
				end
			end
		end
	end
end
