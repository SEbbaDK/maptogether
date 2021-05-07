import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';
@JsonSerializable()
class MapTogether{
  @JsonKey(defaultValue: null)
  final List<User>? users;
  @JsonKey(defaultValue: null)
  final List<Leaderboard>? leaderboards;
  @JsonKey(defaultValue: null)
  final List<SimpleUser>? simple_users;

  MapTogether({ required this.users, required this.leaderboards, required this.simple_users});

  factory MapTogether.fromJson(Map<String, dynamic> json) => _$MapTogetherFromJson(json);
  Map<String, dynamic> toJson() => _$MapTogetherToJson(this);
}

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
class SimpleUser {
  final int id;
  final String name;

  SimpleUser({
    required this.id,
    required this.name,
  });

  factory SimpleUser.fromJson(Map<String, dynamic> json) => _$SimpleUserFromJson(json);
  Map<String, dynamic> toJson() => _$SimpleUserToJson(this);
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
class Leaderboard{
  final List<SimpleUser> user;
  final int score;

  Leaderboard({required this.user, required this.score});

  factory Leaderboard.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardFromJson(json);
  Map<String, dynamic> toJson() => _$LeaderboardToJson(this);
}
