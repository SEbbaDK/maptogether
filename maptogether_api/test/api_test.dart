import 'package:test/test.dart';
import 'package:maptogether_api/src/api.dart';


void main(){
  group('Maptogether reads', () {
    final api = MapTogetherApi('non-functional-key');

    test('Fetching user score', () async {
      var result = (await api.user(1));
      expect(result , isNotNull);
    });

    test('Fetching Leaderboard', () async {
      var result = (await api.globalLeaderboard(LeaderboardType.all_time));
      expect(result, isNotNull);
    });

    test('Erroring when updating user', () async =>
      expect(() async => await api.createUser(1, "", "", ""), throwsException)
    );
  });
}
