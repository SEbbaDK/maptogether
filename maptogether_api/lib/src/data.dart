import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class User{
  final int id, score;
  final String name;

  @JsonKey(defaultValue: null)
  final List<Achievement> achievements;
  @JsonKey(defaultValue: null)
  final List<SimpleUser> followers;
  @JsonKey(defaultValue: null)
  final List<SimpleUser> following;

  User(
      {required this.id,
      required this.score,
      required this.name,
      required this.achievements,
      required this.followers,
      required this.following});

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

  SimpleUser({ required this.id,  required this.name,});

  factory SimpleUser.fromJson(Map<String, dynamic> json) => _$SimpleUserFromJson(json);
  Map<String, dynamic> toJson() => _$SimpleUserToJson(this);
}

@JsonSerializable()
class LeaderboardEntry{
  SimpleUser user;
  int score;

  LeaderboardEntry({required this.score, required this.user});

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
  Map<String, dynamic> toJson() => _$LeaderboardEntryToJson(this);

}


//@JsonSerializable()
class Leaderboard{
  final String type = '';
  //@JsonKey(defaultValue: null)
  final List<LeaderboardEntry> entries;

  Leaderboard(this.entries);
  factory Leaderboard.fromJson(List<dynamic> json) =>
     Leaderboard(json.map((e) => LeaderboardEntry.fromJson(e)).toList(growable: false));
}
