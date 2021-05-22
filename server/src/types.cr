enum RankType
	Global
	Personal

	def self.from_s(s : String)
		return Global if s == "global"
		return Personal if s == "personal"
		raise "Unknown RankType"
	end

	def to_s : String
		return "global" if self == Global
		return "personal" if self == Personal
		raise "Unknown RankType"
	end

	def to_pretty : String
		to_s.capitalize
	end
end

enum LeaderboardType
	Weekly
	Monthly
	AllTime

	def self.from_s(s : String)
		return Weekly if s == "weekly"
		return Monthly if s == "monthly"
		return AllTime if s == "all_time"
		raise "Unknown LeaderboardType"
	end

	def to_s : String
		return "weekly" if self == Weekly
		return "monthly" if self == Monthly
		return "all_time" if self == AllTime
		raise "Unknown LeaderboardType"
	end

	def to_leaderboard : String
		return Queries::WEEKLY if self == Weekly
		return Queries::MONTHLY if self == Monthly
		return Queries::ALL_TIME if self == AllTime
		raise "Unknown LeaderboardType"
	end
end
