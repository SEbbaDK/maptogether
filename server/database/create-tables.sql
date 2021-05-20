CREATE TABLE IF NOT EXISTS users (
	userID	bigint PRIMARY KEY,
	name	varchar(255),
	access	varchar
);

CREATE TABLE IF NOT EXISTS contributionTypes (
	contributionTypeID	SERIAL PRIMARY KEY,
	type 				varchar
);

CREATE TABLE IF NOT EXISTS contributions (
	contributionID	BIGSERIAL PRIMARY KEY,
	userID			bigint REFERENCES users(userID),
	type			integer REFERENCES contributionTypes(contributionTypeID),
	changeSet		bigint,
	score			integer,
	dateTime		timestamptz
);


CREATE TABLE IF NOT EXISTS achievements (
	achievementID	BIGSERIAL PRIMARY KEY,
	name			varchar,
	description		varchar
);

CREATE TABLE IF NOT EXISTS unlocked (
	userID 		bigint REFERENCES users(userID),
	achievement	bigint REFERENCES achievements(achievementID),
	PRIMARY KEY	(userID, achievement)

);

CREATE TABLE IF NOT EXISTS follows (
	follower	bigint REFERENCES users(userID),
	followee	bigint REFERENCES users(userID),
	PRIMARY KEY (follower, followee)
);

CREATE TABLE IF NOT EXISTS groups (
	groupID BIGSERIAL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS hasMember (
	groupID	bigint REFERENCES groups(groupID),
	userID	bigint REFERENCES users(userID),
	PRIMARY KEY (groupID, userID)
);
