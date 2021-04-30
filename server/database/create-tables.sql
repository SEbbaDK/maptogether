CREATE TABLE users (
	userID	integer PRIMARY KEY,
	name	varchar(20)
);

CREATE TABLE contributions (
	contributionID	SERIAL PRIMARY KEY,
	userID			integer REFERENCES users(userID),
	type			varchar(30) REFERENCES contributionTypes(type),
	changeSet		integer,
	score			integer
);

CREATE TABLE contributionTypes (
	type varchar(30) PRIMARY KEY
);

CREATE TABLE achievements (
	name	varchar(50)	PRIMARY KEY
);

CREATE TABLE unlocked (
	userID 		integer REFERENCES users(userID),
	achievement	varchar(50) REFERENCES achievements(name),
	PRIMARY KEY	(userID, achievement)

);

CREATE TABLE follows (
	follower	integer REFERENCES users(userID),
	followee	integer REFERENCES users(userID),
	PRIMARY KEY (follower, followee)
);

CREATE TABLE groups (
	groupID SERIAL PRIMARY KEY
);

CREATE TABLE hasMember (
	groupID	integer REFERENCES groups(groupID),
	userID	integer REFERENCES users(userID),
	PRIMARY KEY (groupID, userID)
);