import 'package:maptogether_api/maptogether_api.dart';

Future<User> getUser() async{
  //This should call to get all the leaderboards in the future
  final api = MapTogetherApi();
  var user = await api.user(2);
  return user;
}

Future<List<Leaderboard>> getLeaderboards(LeaderboardType type) async{
  //This should call to get all the leaderboards in the future
  final api = MapTogetherApi();
  var l = await api.globalLeaderboard(type);
  List<Leaderboard> lst = [l];
  return lst;
}