require "./types.cr"

class Placement
	property path : String
	property name : String
	property type : LeaderboardType
	property rank : Int64
	property total : Int64

	def initialize(
		id : Int64,
		r : RankType,
		@type : LeaderboardType,
		@rank : Int64,
		@total : Int64
	)
		@path = "#{@type.to_s}/#{r.to_s}"
		@path += "/#{id}" if r == RankType::Personal
		@name = r.to_pretty
	end

	def to_json(json : JSON::Builder)
		json.object do
			json.field "path", @path
			json.field "name", @name
			json.field "type", @type.to_s
			json.field "rank", @rank
			json.field "total", @total
		end
	end
end
