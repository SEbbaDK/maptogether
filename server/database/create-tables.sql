CREATE TABLE IF NOT EXISTS users (
	userID	integer PRIMARY KEY,
	name	varchar(20)
);

CREATE TABLE IF NOT EXISTS contributionTypes (
	type varchar(30) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS contributions (
	contributionID	SERIAL PRIMARY KEY,
	userID			integer REFERENCES users(userID),
	type			varchar(30) REFERENCES contributionTypes(type),
	changeSet		integer,
	score			integer
);


CREATE TABLE IF NOT EXISTS achievements (
	name	varchar(50)	PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS unlocked (
	userID 		integer REFERENCES users(userID),
	achievement	varchar(50) REFERENCES achievements(name),
	PRIMARY KEY	(userID, achievement)

);

CREATE TABLE IF NOT EXISTS follows (
	follower	integer REFERENCES users(userID),
	followee	integer REFERENCES users(userID),
	PRIMARY KEY (follower, followee)
);

CREATE TABLE IF NOT EXISTS groups (
	groupID SERIAL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS hasMember (
	groupID	integer REFERENCES groups(groupID),
	userID	integer REFERENCES users(userID),
	PRIMARY KEY (groupID, userID)
);
