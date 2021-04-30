CREATE TABLE user (
	userID	integer PRIMARY KEY,
	name	varchar(20)
);

CREATE TABLE contribution (
	contributionID	SERIAL PRIMARY KEY,
	userID			integer REFERENCES user(userID),
	type			varchar(30) REFERENCES contributionType(type),
	changeSet		integer,
	score			integer
);

CREATE TABLE contributionType (
	type varchar(30) PRIMARY KEY
);

CREATE TABLE achievement (
	name	varchar(50)	PRIMARY KEY
);

CREATE TABLE unlocked (
	userID 		integer REFERENCES user(userID),
	achievement	varchar(50) REFERENCES achievement(name),
	PRIMARY KEY	(userID, achievement)

);

CREATE TABLE follows (
	follower	integer REFERENCES user(userID),
	followee	integer REFERENCES user(userID),
	PRIMARY KEY (follower, followee)
);

CREATE TABLE group (
	groupID SERIAL PRIMARY KEY
)

CREATE TABLE hasMember (
	groupID	integer REFERENCES group(groupID),
	userID	integer REFERENCES user(userID),
	PRIMARY KEY (groupID, userID)
)