import 'package:test/test.dart';
import 'package:maptogether_api/src/api.dart' as api;


void main(){
  group('Maptogether reads', () {
    final mapTogetherApi = api.MapTogetherApi();

    test('Fetching user score', () async {
      var result = (await mapTogetherApi.user(1)).score;
      expect(result, 23);
    });

    test('Fetching Leaderboard', () async {
      var result = (await mapTogetherApi.globalLeaderboard(api.LeaderboardType.all_time)).user;
      expect(result.length, 60);
    });
  });
}