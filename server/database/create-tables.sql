CREATE TABLE IF NOT EXISTS users (
	userID	integer PRIMARY KEY,
	name	varchar(20)
);

CREATE TABLE IF NOT EXISTS contributionTypes (
	contributionTypeID	SERIAL PRIMARY KEY,
	type 				varchar
);

CREATE TABLE IF NOT EXISTS contributions (
	contributionID	SERIAL PRIMARY KEY,
	userID			integer REFERENCES users(userID),
	type			integer REFERENCES contributionTypes(contributionTypeID),
	changeSet		integer,
	score			integer,
	dateTime		timestamptz
);


CREATE TABLE IF NOT EXISTS achievements (
	achievmentID	SERIAL PRIMARY KEY,
	name			varchar,
	description		varchar
);

CREATE TABLE IF NOT EXISTS unlocked (
	userID 		integer REFERENCES users(userID),
	achievement	varchar REFERENCES achievements(name),
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
