import 'dart:math';

import 'package:maptogether_api/maptogether_api.dart';

import '../lib/src/data.dart';

void main() {
  final api = MapTogetherApi();
  api.user(1).then(print);
  api.globalLeaderboard(LeaderboardType.all_time).then(print);

  api.globalLeaderboard(LeaderboardType.all_time).then((l) {
    print(l.type);

  });

}

