module Queries
	extend self

	def USER_FROM_ID
		"SELECT userID, name 
		FROM users 
		WHERE userID = $1 limit 1"
	end

	def TOTAL_SCORE_FROM_ID 
		"SELECT SUM (score) AS score 
		FROM contributions 
		WHERE userID = $1"
	end

	def ACHIEVEMENTS_FROM_ID 
		"SELECT achievement 
		FROM unlocked 
		WHERE userID = $1"
	end
	
	def FOLLOWERS_FROM_ID 
		"SELECT userID, name 
		FROM follows INNER JOIN users 
			ON follower = userID 
		WHERE followee = $1"
	end

	def FOLLOWING_FROM_ID 
		"SELECT userID, name 
		FROM 
			follows INNER JOIN users 
			ON followee = userID 
		WHERE follower = $1"
	end

	def TOTAL_LEADERBOARD
		"SELECT userID, name, score 
		FROM 
			(SELECT userID, SUM (score) AS score 
			FROM contributions 
			GROUP BY userID) 
			AS s 
			INNER JOIN 
			users AS u 
			ON u.userID = s.userID 
		ORDER BY score DESC"
	end
end