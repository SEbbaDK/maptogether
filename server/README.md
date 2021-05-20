# MapTogether Server

## Endpoints

### `/user/<id>` Get user by id

Responds with json object of a user like this:
```
{
    "id": <id>,
    "name": <name>,
    "score": <total score>,
    "achievements": [
        {
            "name": <achievement name>,
            "description": <achievement desc>
        },
        ...
    ],
    "followers": [
        {
            "id": <follower id>,
            "name": <follower name>
        },
        ...
    ],
    "following": [
        {
            "id": <followee 1 id>,
            "name": <followee 1 name>
        },
        ...
    ],
    "leaderboards": [
        {
            "leaderboard": <leaderboard name (Global/Personal)>,
            "type": <All_Time/Monthly/Weekly>,
            "rank": <rank number>,
            "total": <number of participants>
        },
        ...
    ],
}
```

### `/leaderboard/<time frame>/global` Get Global Leaderboard
Possible time frames:
- all_time
- monthly
- weekly
Responds with a leaderboard that includes all users that (within the time frame) has a score larger than 0.

### `/leaderboard/<time frame>/personal/<id>` Get Personal Leaderboard of Followed Users
Possible time frames:
- all_time
- monthly
- weekly
Responds with a leaderboard that includes all users followed by the user with userID = id (and the user itself). 

All leaderboard endpoints respond with a json object of users' id, name and score sorted by score in descending order
```
[
    {
    	user: {
            id: <user id>,
            name: <user name>
        },
        score: <1. place score>
    },
    ...
]
```

### `/contribution` Post Contribution
Post a new contribution. The JSON object has to include user_id, type, changeset, score and date_time
```
{
    "user_id": <user-id>,
    "type": <id of type of contribution>,
    "changeset": <id of changeset from OSM>,
    "score": <points rewarded>,
    "date_time": <ISO8601 format timestamp>
}
```

### `/user/<id>/following/<followee>` Put Follow Relationship
Add follows relationship such that user with id <id> follows user with id <followee>.

Throws an error if <id> or <followe> does not exist or if the relationship already exist.

### `/user/<id>/<name>` Put New User
Add a new user to the database with id <id> and name <name>.

Throws an error if <id> already exist or if the name is more than 20 characters.

### `/user/<id>/following/<followee>` Delete Follow Relationship
Deletes the follows relationship such that user with id <id> no longer follows user with id <followee>.

Throws an error if the relation does not exist.
