import 'package:test/test.dart';
import 'package:maptogether_api/src/api.dart' as mt;

void main() {
  group('Maptogether reads', () {
    final api = mt.Api('non-functional-key');

    test('Fetching user score', () async {
      var result = (await api.user(1));
      expect(result, isNotNull);
    });

    test('Fetching Leaderboard', () async {
      var result = (await api.globalLeaderboard(mt.LeaderboardType.all_time));
      expect(result, isNotNull);
    });

    test(
        'Erroring when updating user',
        () async => expect(
            () async => await api.createUser(1, "", "", ""), throwsException));
  });
}
