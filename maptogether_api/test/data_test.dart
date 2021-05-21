import 'package:test/test.dart';
import 'package:maptogether_api/src/data.dart' as data;

void main() {
  group('User', () {
    var user = data.User(id: 1, score: 12, name: 'Jens', achievements: [
      data.Achievement(
        name: 'fdf',
        description: 'Stuff',
      )
    ], followers: [
      data.SimpleUser(
        id: 1,
        name: 'Hej',
      )
    ], following: [
      data.SimpleUser(id: 2, name: 'Med')
    ], leaderboards: [
      data.LeaderboardSummary(
          path: "/leaderboard/all_time/global",
          name: "Global",
          rank: 1,
          total: 20,
          type: data.LeaderboardType.all_time)
    ]);

    test('have', () => expect(user.followers.length, 1));
  });
}
