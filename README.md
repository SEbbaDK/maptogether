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
        <achievement name>,
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
{
    users: [
        {
            id: <user id>,
            name: <user name>,
            score: <1. place score>
        },
        ...
    ]
}
```
