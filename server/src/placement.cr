enum Leaderboard_Type
	Weekly
	Monthly
	All_Time

	def to_string
		"Weekly" if self == Leaderboard_Type::Weekly
		"Monthly" if self == Leaderboard_Type::Monthly
		"All_time" if self == Leaderboard_Type::All_Time
	end
end

class Placement
	property leaderboard : String
	property type : Leaderboard_Type
	property rank : Int64
	property total : Int64

	def initialize(
		@leaderboard : String,
		@type : Leaderboard_Type,
		@rank : Int64,
		@total : Int64
	)
	end

	def to_json(json : JSON::Builder)
		json.object do
			json.field "leaderboard", @leaderboard
			json.field "type", @type.to_string
			json.field "rank", @rank
			json.field "total", @total
		end
	end
end