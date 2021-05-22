require "./types.cr"

module Queries
	extend self

	ALL_TIME = "leaderboardAllTime"
	MONTHLY	= "leaderboardMonthly"
	WEEKLY	 = "leaderboardWeekly"

	LEADERBOARDS = [ALL_TIME, MONTHLY, WEEKLY]

	USER_UPSERT = "
		INSERT INTO users(userID, name, access)
		VALUES ($1, $2, $3)
		ON CONFLICT(userID) DO
			UPDATE SET name = EXCLUDED.name, access = EXCLUDED.access
	"

	USER_FROM_ID = "
		SELECT userID, name
		FROM users
		WHERE userID = $1 limit 1
	"

	def score_from_id(l : LeaderboardType)
		"
		SELECT score
		FROM #{l.to_leaderboard}
		WHERE userID = $1
			"
	end

	ACHIEVEMENTS_FROM_ID = "
		SELECT a.name, a.description
		FROM
			(SELECT *
			FROM unlocked
			WHERE userID = $1) AS u
			INNER JOIN
			achievements AS a
			ON u.achievement = a.achievementID
		"

	FOLLOWERS_FROM_ID = "
		SELECT userID, name
		FROM follows INNER JOIN users
			ON follower = userID
		WHERE followee = $1
	"

	FOLLOWING_FROM_ID = "
		SELECT userID, name
		FROM follows INNER JOIN users
			ON followee = userID
		WHERE follower = $1
	"

	def rank_and_count(r : RankType, l : LeaderboardType)
		if r == RankType::Global
			"
					SELECT *
					FROM
				(
						SELECT l.rnum as rank
						FROM (
							SELECT userID, score, row_number() OVER () as rnum
							FROM #{l.to_leaderboard}
							WHERE score != 0 OR userID = $1) AS l
						WHERE userID = $1
					) as r
					CROSS JOIN
					(
						SELECT COUNT(*) as count
						FROM #{l.to_leaderboard}
						WHERE score != 0 OR userID = $1
				) as c
					"
		else
			"
					SELECT *
					FROM
					(
				SELECT l.rnum as rank
				FROM (
					SELECT userID, score, row_number() OVER () as rnum
					FROM #{l.to_leaderboard}
					WHERE
						EXISTS (
						SELECT 1
						FROM follows
						WHERE userID = $1 OR (follower = $1 AND followee = userID)
					)
					AND
					(score != 0 OR userID = $1)) AS l
						WHERE userID = $1
				) as r
				CROSS JOIN
				(
						SELECT COUNT(*) as count
						FROM #{l.to_leaderboard}
						WHERE
						EXISTS (
							SELECT 1
							FROM follows
							WHERE userID = $1 OR (follower = $1 AND followee = userID)
						) AND (score != 0 OR userID = $1)
				) as c
						"
		end
	end

	def leaderboard(r : RankType, l : LeaderboardType)
		if r == RankType::Global
			"
		SELECT *
		FROM #{l.to_leaderboard}
		WHERE score != 0
			"
		else
			"
		SELECT *
		FROM #{l.to_leaderboard}
		WHERE EXISTS (
			SELECT 1
			FROM follows
			WHERE userID = $1 OR (follower = $1 AND followee = userID)
		)
			"
		end
	end
end
