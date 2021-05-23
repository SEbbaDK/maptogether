import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data.dart' as data;

class InvalidRegionException implements Exception {
  final String _message;
  InvalidRegionException(
      [this._message = 'Region cannot be global or leaderboard']);
  @override
  String toString() => _message;
}

class Api {
  final String _url = 'https://maptogether.sebba.dk/api/';

  final String _access;
  Api(String access) : _access = access;

  Map<String, String> _authHeader(String? auth) =>
      {'Authorization': 'Basic ${auth != null ? auth : _access}'};

  // Internal http methods

  Future<http.Response> _get(String path) => http.get(Uri.parse(_url + path));

  Future<http.Response> _put(String path, {String? auth}) =>
      http.put(Uri.parse(_url + path), headers: _authHeader(auth));

  Future<http.Response> _del(String path, {String? auth}) =>
      http.delete(Uri.parse(_url + path), headers: _authHeader(auth));

  // Stream handlers

  String Function(http.Response) _checkRequest(String description) =>
      (http.Response res) {
        if (res.statusCode != 200)
          throw Exception('HTTP error ${res.statusCode} when $description');
        else
          return res.body;
      };

  data.User _decodeUser(String input) => data.User.fromJson(jsonDecode(input));

  data.Leaderboard _decodeLeaderboard(String input) =>
      data.Leaderboard.fromJson(jsonDecode(input));

  // Pull Endpoints

  Future<data.User> user(int id) =>
      _get('user/$id').then(_checkRequest('getting user')).then(_decodeUser);

  leaderboardByPath(String path) => _get('leaderboard/$path')
      .then(_checkRequest('getting leaderboard'))
      .then(_decodeLeaderboard);

  Future<data.Leaderboard> leaderboard(
          data.LeaderboardType type, String name) =>
      leaderboardByPath('${type.stringify()}/$name');

  Future<data.Leaderboard> personalLeaderboard(
          data.LeaderboardType type, int id) =>
      leaderboard(type, 'personal/${id}');

  Future<data.Leaderboard> globalLeaderboard(data.LeaderboardType type) =>
      leaderboard(type, 'global');

  // Push Endpoints

  Future<void> createUser(
          int id, String secret, String clientToken, String clientSecret) =>
      _put('user/$id', auth: '$_access $secret $clientToken $clientSecret')
          .then(_checkRequest('creating user'));

  Future<void> follow(int id, int otherId) =>
      _put('user/$id/following/$otherId').then(_checkRequest('following a user'));

  Future<void> unfollow(int id, int other) => _del('user/$id/following/$other')
      .then(_checkRequest('unfollowing a user'));
}
