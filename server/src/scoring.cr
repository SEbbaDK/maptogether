require "./user.cr"

class Scoring
    getter user : User, score : Int64
    def initialize(@user, @score)
    end
    
	def to_json (json_builder json : JSON::Builder)
		json.object do
    		json.field "user", @user.to_json
    		json.field "score", @score
		end
	end
end
