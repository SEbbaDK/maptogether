import 'package:maptogether_api/maptogether_api.dart';

void main() {
	final api = MapTogetherApi();
	api.user(1).then(print);
	api.globalLeaderboard(LeaderboardType.all_time).then(print);
}
