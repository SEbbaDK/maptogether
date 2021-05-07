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
    ]
    "followers": [
        {
            "id": <follower id>,
            "name": <follower name>
        },
        ...
    ]
    "following": [
        {
            "id": <followee 1 id>,
            "name": <followee 1 name>
        },
        ...
    ]
}
```

### `/leaderboard/global/all_time` Get Global All-time Leaderboard

Responds with a json object of all users' id, name and score sorted by score in descending order
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
