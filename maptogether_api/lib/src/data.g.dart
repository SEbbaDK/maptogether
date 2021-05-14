// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    score: json['score'] as int,
    name: json['name'] as String,
    achievements: (json['achievements'] as List<dynamic>)
        .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
        .toList(),
    followers: (json['followers'] as List<dynamic>)
        .map((e) => SimpleUser.fromJson(e as Map<String, dynamic>))
        .toList(),
    following: (json['following'] as List<dynamic>)
        .map((e) => SimpleUser.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'score': instance.score,
      'name': instance.name,
      'achievements': instance.achievements,
      'followers': instance.followers,
      'following': instance.following,
    };

Achievement _$AchievementFromJson(Map<String, dynamic> json) {
  return Achievement(
    name: json['name'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$AchievementToJson(Achievement instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };

Contribution _$ContributionFromJson(Map<String, dynamic> json) {
  return Contribution(
    user_id: json['user_id'] as int,
    type: json['type'] as int,
    changeset: json['changeset'] as int,
    score: json['score'] as int,
    date_time: DateTime.parse(json['date_time'] as String),
  );
}

Map<String, dynamic> _$ContributionToJson(Contribution instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'type': instance.type,
      'changeset': instance.changeset,
      'score': instance.score,
      'date_time': instance.date_time.toIso8601String(),
    };

SimpleUser _$SimpleUserFromJson(Map<String, dynamic> json) {
  return SimpleUser(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$SimpleUserToJson(SimpleUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) {
  return LeaderboardEntry(
    user: SimpleUser.fromJson(json['user'] as Map<String, dynamic>),
    score: json['score'] as int,
  );
}

Map<String, dynamic> _$LeaderboardEntryToJson(LeaderboardEntry instance) =>
    <String, dynamic>{
      'user': instance.user,
      'score': instance.score,
    };

Leaderboard _$LeaderboardFromJson(Map<String, dynamic> json) {
  return Leaderboard(
    user: (json['user'] as List<dynamic>)
        .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$LeaderboardToJson(Leaderboard instance) =>
    <String, dynamic>{
      'user': instance.user,
    };
