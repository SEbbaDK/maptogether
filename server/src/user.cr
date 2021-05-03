class User
	property userID : Nil | Int32 
	property score : Nil | Int32
	property name : Nil | String
	property achievements : Array(String)
	property followers : Array(User)
	property following : Array(User)

	def initialize (
			@userID = nil,
			@score = nil,
			@name = nil,
			@achievements = [] of String,
			@followers = [] of User,
			@following = [] of User
		)
	end

	def toJson (jsonBuilder json : JSON::Builder)
		json.object do
			json.field "id", userID unless userID.nil?
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
						follower.toJson(json)
					end
				end
			end

			foling = following
			json.field "following" do
				json.array do
					foling.each do |followee|
						followee.toJson(json)
					end
				end
			end
		end
	end
end