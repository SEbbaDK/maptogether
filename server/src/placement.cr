enum Leaderboard_Type
	Weekly
	Monthly
	All_Time

	def to_string
		"weekly" if self == Leaderboard_Type::Weekly
		"monthly" if self == Leaderboard_Type::Monthly
		"all_time" if self == Leaderboard_Type::All_Time
	end
end

class Placement
	property path : String
	property name : String
	property type : Leaderboard_Type
	property rank : Int64
	property total : Int64

	def initialize(
		@path : String,
		@name : String,
		@type : Leaderboard_Type,
		@rank : Int64,
		@total : Int64
	)
	end

	def to_json(json : JSON::Builder)
		json.object do
			json.field "path", @path
			json.field "name", @name
			json.field "type", @type.to_string
			json.field "rank", @rank
			json.field "total", @total
		end
	end
end