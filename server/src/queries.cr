module Queries
	extend self

	USER_FROM_ID =
		"SELECT userID, name
		FROM users
		WHERE userID = $1 limit 1"

	TOTAL_SCORE_FROM_ID =
		"SELECT SUM (score) AS score
		FROM contributions
		WHERE userID = $1"

	ACHIEVEMENTS_FROM_ID =
		"SELECT achievement
		FROM unlocked
		WHERE userID = $1"

	FOLLOWERS_FROM_ID =
		"SELECT userID, name
		FROM follows INNER JOIN users
			ON follower = userID
		WHERE followee = $1"

	FOLLOWING_FROM_ID =
		"SELECT userID, name
		FROM
			follows INNER JOIN users
			ON followee = userID
		WHERE follower = $1"

	GLOBAL_ALL_TIME =
		"SELECT u.userID, u.name, s.score
		FROM
			(SELECT userID, SUM (score) AS score
			FROM contributions
			GROUP BY userID)
			AS s
			INNER JOIN
			users AS u
			ON u.userID = s.userID
		ORDER BY score DESC"

	GLOBAL_INTERVAL =
		"SELECT u.userID, u.name, s.score
		FROM
			(SELECT userID, SUM (score) AS score
			FROM contributions
			WHERE dateTime > $1 AND datetime < $2
			GROUP BY userID)
			AS s
			INNER JOIN
			users AS u
			ON u.userID = s.userID
		ORDER BY score DESC"
end
