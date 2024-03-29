import 'package:json_annotation/json_annotation.dart';
import 'package:maptogether_api/src/api.dart';

part 'data.g.dart';

@JsonSerializable()
class User {
  final int id;
  @JsonKey(name: "score_all_time")
  final int scoreAllTime;
  @JsonKey(name: "score_monthly")
  final int scoreMonthly;
  @JsonKey(name: "score_weekly")
  final int scoreWeekly;
  final String name;

  final List<Achievement> achievements;
  final List<SimpleUser> followers;
  final List<SimpleUser> following;
  final List<LeaderboardSummary> leaderboards;

  User(
      {required this.id,
      required this.scoreAllTime,
      required this.scoreMonthly,
      required this.scoreWeekly,
      required this.name,
      required this.achievements,
      required this.followers,
      required this.following,
      required this.leaderboards});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Achievement {
  final String name;

  final String description;

  Achievement({
    required this.name,
    required this.description,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementToJson(this);
}

@JsonSerializable()
class Contribution {
  final int user_id, type, changeset, score;
  final DateTime date_time;

  Contribution(
      {required this.user_id,
      required this.type,
      required this.changeset,
      required this.score,
      required this.date_time});

  factory Contribution.fromJson(Map<String, dynamic> json) =>
      _$ContributionFromJson(json);
  Map<String, dynamic> toJson() => _$ContributionToJson(this);
}

@JsonSerializable()
class SimpleUser {
  final int id;
  final String name;

  SimpleUser({
    required this.id,
    required this.name,
  });

  factory SimpleUser.fromJson(Map<String, dynamic> json) =>
      _$SimpleUserFromJson(json);
  Map<String, dynamic> toJson() => _$SimpleUserToJson(this);
}

@JsonSerializable()
class LeaderboardEntry {
  SimpleUser user;
  int score;

  LeaderboardEntry({required this.score, required this.user});

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
  Map<String, dynamic> toJson() => _$LeaderboardEntryToJson(this);
}

//@JsonSerializable()
class Leaderboard {
  final String type = '';
  //@JsonKey(defaultValue: null)
  final List<LeaderboardEntry> entries;

  Leaderboard(this.entries);
  factory Leaderboard.fromJson(List<dynamic> json) => Leaderboard(
      json.map((e) => LeaderboardEntry.fromJson(e)).toList(growable: false));
}

@JsonSerializable()
class LeaderboardSummary {
  final String path, name;
  final int rank, total;

  @JsonKey(fromJson: LeaderboardTypeExtension.fromString)
  final LeaderboardType type;

  LeaderboardSummary(
      {required this.path,
      required this.name,
      required this.rank,
      required this.total,
      required this.type});

  factory LeaderboardSummary.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$LeaderboardSummaryToJson(this);
}

enum LeaderboardType { weekly, monthly, all_time }

extension LeaderboardTypeExtension on LeaderboardType {
  String stringify() {
    switch (this) {
      case LeaderboardType.weekly:
        return "weekly";
      case LeaderboardType.monthly:
        return "monthly";
      case LeaderboardType.all_time:
        return 'all_time';
    }
    throw 'Leaderboard type does not exsist';
  }

  static LeaderboardType fromString(String type) {
    switch (type) {
      case "weekly":
        return LeaderboardType.weekly;
      case "monthly":
        return LeaderboardType.monthly;
      case "all_time":
        return LeaderboardType.all_time;
      default:
        return LeaderboardType.all_time;
    }
  }
}
