CREATE TABLE user(
	userID	serial PRIMARY KEY,
	name	varchar(20),
	score	integer
);

CREATE TABLE contribution(
	contributionID  serial PRIMARY KEY,
	type			varchar(30) REFERENCES contributionType(type)
);

CREATE TABLE contributionType(
	type	varchar(30) PRIMARY KEY
);

CREATE TABLE achievement(
	name	varchar(30)	PRIMARY KEY
);

CREATE TABLE unlocked(
	userID 		serial REFERENCES user(userID),
	achievement	varchar(30) REFERENCES achievement(name),
	PRIMARY KEY	(userID, achievement)

);

CREATE TABLE follows(
	follower	serial REFERENCES user(userID),
	followee	serial REFERENCES user(userID),
	PRIMARY KEY (follower, followee)
);
