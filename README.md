# MapTogether

![](client/ios/Runner/Assets.xcassets/AppIcon.appiconset/180.png)

MapTogether is a FOSS application, meant as a cross-platform and more featureful version of [StreetComplete](https://github.com/streetcomplete/StreetComplete).
There is still many milestones before this is achieved, but the current implementation already has quest-generation and -solving, cross-platform support and social features like weekly leaderboards and a friend system.

This repo is structured as a monorepo, to make sure things like the `maptogether_api` and the `server` can be updated atomically.

## [The Client](client/)

The client takes care of all rendering and communication with the OpenStreetMap servers.
The client does not contact the MapTogether servers unless specifically being opted into.

## [The Server](server/)

The server is the setup for the social features of the app.
It's only contacted with opt-in, as the client otherwise handles all features.

## The Api-Wrappers

[`osm_api`](osm_api/) and [`maptogether_api`](maptogether_api/) both contain Dart wrappers for the v0.6 OpenStreetMap api and the MapTogether api.
They are functionally very similar, both being async apis and having an authentication presetup.
