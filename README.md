# MapTogether Server

## Endpoints

### Requests
#### Get user by id
`/user/<id>`

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
#### Get Global All-time Leaderboard
`/leaderboard/global/all_time`

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
