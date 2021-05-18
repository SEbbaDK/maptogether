import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data.dart' as data;

enum LeaderboardType { weekly, montly, all_time }
String stringify(LeaderboardType type) {
  switch (type) {
    case LeaderboardType.weekly:
      return "weekly";
    case LeaderboardType.montly:
      return "montly";
    case LeaderboardType.all_time:
      return "all_time";
  }
  throw 'Leaderboard type does not exsist';
}

class InvalidRegionException implements Exception {
  final String _message;
  InvalidRegionException(
      [this._message = 'Region cannot be global or leaderboard']);
  @override
  String toString() => _message;
}

class MapTogetherApi {
  final String _url = 'https://maptogether.sebba.dk/api/';

  Future<http.Response> _get(String path) => http.get(Uri.parse(_url + path));

  String Function(http.Response) _checkRequest(String description) =>
      (http.Response res) {
        if (res.statusCode != 200)
          throw Exception('HTTP error ${res.statusCode} when $description');
        else
          return res.body;
      };


  data.User _decodeUser(String input) =>
      data.User.fromJson(jsonDecode(input));

  data.Leaderboard _decodeLeaderboard(String input) =>
      data.Leaderboard.fromJson(jsonDecode(input));

  Future<data.User> user(int id) =>
      _get('user/$id').then(_checkRequest('getting user')).then(_decodeUser);

  Future<data.Leaderboard> leaderboard(String base, LeaderboardType type) =>
      _get('leaderboard/$base/${stringify(type)}')
          .then(_checkRequest('getting leaderboard')).then(_decodeLeaderboard);

  Future<data.Leaderboard> personalLeaderboard(LeaderboardType type) =>
      leaderboard('personal', type);

  Future<data.Leaderboard> globalLeaderboard(LeaderboardType type) =>
      leaderboard('global', type);

  Future<data.Leaderboard> regionalLeaderboard(String region, LeaderboardType type) {
    if (region == 'personal' || region == 'global')
      throw InvalidRegionException();
    else
      return leaderboard(region, type);
  }
}
