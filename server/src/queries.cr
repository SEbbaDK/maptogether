module Queries
	extend self

	USER_UPSERT = "
		INSERT INTO users
		VALUES ($1, $2, $3)
		ON CONFLICT(userid) DO
			UPDATE SET name = EXCLUDED.name, access = EXCLUDED.access
	"

	USER_FROM_ID = "
		SELECT userID, name
		FROM users
		WHERE userID = $1 limit 1
	"

	TOTAL_SCORE_FROM_ID =
		"SELECT COALESCE(SUM(score),0) AS score
		FROM contributions
		WHERE userID = $1
	"

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

	GLOBAL_ALL_TIME_RANK = "
		SELECT l.rnum
		FROM (
			SELECT userID, score, row_number() OVER () as rnum
			FROM leaderboardAllTime
			WHERE score != 0 OR userID = $1) AS l
		WHERE userID = $1
	"

	GLOBAL_MONTHLY_RANK = "
		SELECT l.rnum
		FROM (
			SELECT userID, score, row_number() OVER () as rnum
			FROM leaderboardMonthly
			WHERE score != 0 OR userID = $1) AS l
		WHERE userID = $1
	"

	GLOBAL_WEEKLY_RANK = "
		SELECT l.rnum
		FROM (
			SELECT userID, score, row_number() OVER () as rnum
			FROM leaderboardWeekly
			WHERE score != 0 OR userID = $1) AS l
		WHERE userID = $1
	"

	PERSONAL_ALL_TIME_RANK = "
		SELECT l.rnum
		FROM (
			SELECT userID, score, row_number() OVER () as rnum
			FROM leaderboardAllTime
			WHERE
				EXISTS (
				SELECT 1
				FROM follows
						WHERE userID = $1 OR (follower = $1 AND followee = userID)
			)
			AND
			(score != 0 OR userID = $1)) AS l
		WHERE userID = $1
	"

	PERSONAL_MONTHLY_RANK = "
		SELECT l.rnum
		FROM (
			SELECT userID, score, row_number() OVER () as rnum
			FROM leaderboardMonthly
			WHERE
				EXISTS (
				SELECT 1
				FROM follows
						WHERE userID = $1 OR (follower = $1 AND followee = userID)
			)
			AND
			(score != 0 OR userID = $1)) AS l
		WHERE userID = $1
	"

	PERSONAL_WEEKLY_RANK = "
		SELECT l.rnum
		FROM (
			SELECT userID, score, row_number() OVER () as rnum
			FROM leaderboardWeekly
			WHERE
				EXISTS (
				SELECT 1
				FROM follows
						WHERE userID = $1 OR (follower = $1 AND followee = userID)
			)
			AND
			(score != 0 OR userID = $1)) AS l
		WHERE userID = $1
	"

	PERSONAL_ALL_TIME_COUNT = "
		SELECT COUNT(*)
		FROM leaderboardAllTime
		WHERE
		EXISTS (
			SELECT 1
			FROM follows
			WHERE userID = $1 OR (follower = $1 AND followee = userID)
		)
		AND
			(score != 0 OR userID = $1)
	"

	PERSONAL_MONTHLY_COUNT = "
		SELECT COUNT(*)
		FROM leaderboardMonthly
		WHERE
		EXISTS (
			SELECT 1
			FROM follows
			WHERE userID = $1 OR (follower = $1 AND followee = userID)
		)
		AND
			(score != 0 OR userID = $1)
	"

	PERSONAL_WEEKLY_COUNT = "
		SELECT COUNT(*)
		FROM leaderboardWeekly
		WHERE
		EXISTS (
			SELECT 1
			FROM follows
			WHERE userID = $1 OR (follower = $1 AND followee = userID)
		)
		AND
			(score != 0 OR userID = $1)
	"

	GLOBAL_ALL_TIME_COUNT = "
		SELECT COUNT(*)
		FROM leaderboardAllTime
		WHERE score != 0
	"

	GLOBAL_MONTHLY_COUNT = "
		SELECT COUNT(*)
		FROM leaderboardMonthly
		WHERE score != 0
	"

	GLOBAL_WEEKLY_COUNT = "
		SELECT COUNT(*)
		FROM leaderboardWeekly
		WHERE score != 0
	"

	GLOBAL_ALL_TIME = "
		SELECT *
		FROM leaderboardAllTime
		WHERE score != 0
	"

	GLOBAL_MONTHLY = "
		SELECT *
		FROM leaderboardMonthly
		WHERE score != 0
	"

	GLOBAL_WEEKLY = "
		SELECT *
		FROM leaderboardWeekly
		WHERE score != 0
	"

	PERSONAL_ALL_TIME = "
		SELECT *
		FROM leaderboardAllTime
		WHERE
			EXISTS (
				SELECT 1
				FROM follows
				WHERE userID = $1 OR (follower = $1 AND followee = userID)
			)
	"

	PERSONAL_MONTHLY = "
		SELECT *
		FROM leaderboardMonthly
		WHERE
			EXISTS (
				SELECT 1
				FROM follows
				WHERE userID = $1 OR (follower = $1 AND followee = userID)
			)
	"

	PERSONAL_WEEKLY = "
		SELECT *
		FROM leaderboardWeekly
		WHERE
			EXISTS (
				SELECT 1
				FROM follows
				WHERE userID = $1 OR (follower = $1 AND followee = userID)
			)
	"
end
