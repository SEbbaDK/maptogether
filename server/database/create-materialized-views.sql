CREATE MATERIALIZED VIEW leaderboardAllTime AS
	SELECT u.userID, u.name, COALESCE(s.score, 0) AS score
	FROM (
		SELECT userID, SUM (score) AS score
		FROM contributions
		GROUP BY userID
		) AS s
		RIGHT OUTER JOIN
		users AS u
		ON u.userID = s.userID
	ORDER BY score DESC;

CREATE MATERIALIZED VIEW leaderboardWeekly AS
	SELECT u.userID, u.name, COALESCE(s.score, 0) AS score
		FROM (
			SELECT userID, SUM (score) AS score
			FROM contributions
			WHERE dateTime BETWEEN date_trunc('week', CURRENT_DATE) AND NOW()
			GROUP BY userID
			) AS s
			RIGHT OUTER JOIN
			users AS u
			ON u.userID = s.userID
		ORDER BY score DESC;

CREATE MATERIALIZED VIEW leaderboardMonthly AS
	SELECT u.userID, u.name, COALESCE(s.score, 0) AS score
		FROM (
			SELECT userID, SUM (score) AS score
			FROM contributions
			WHERE dateTime BETWEEN date_trunc('month', CURRENT_DATE) AND NOW()
			GROUP BY userID
			) AS s
			RIGHT OUTER JOIN
			users AS u
			ON u.userID = s.userID
		ORDER BY score DESC;
