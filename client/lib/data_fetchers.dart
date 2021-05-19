import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maptogether_api/maptogether_api.dart';


Future<User> getUser() async{
  //This should call to get all the leaderboards in the future
  final api = MapTogetherApi();
  var user = await api.user(2);
  return user;
}

Future<Leaderboard> getLeaderboard(LeaderboardType type, String name) async{
  //This should call to get all the leaderboards in the future
  final api = MapTogetherApi();
  var lb = await api.leaderboard(name, type);
  //var regional = await api.regionalLeaderboard("Denmark", type);
  //var follower = await api.personalLeaderboard(type);
  return lb;
}

SizedBox waitingLoop() {
      return SizedBox(
            child: CircularProgressIndicator(),
              width: 60,
              height: 60,
  );
}

Widget errorData() {
  return Icon(
    Icons.error_outline,
    color: Colors.red,
    size: 60,
  );
}

//should return the full list of leaderboard names
List<String> getLeaderboardNames(){
  return ["global"];
}