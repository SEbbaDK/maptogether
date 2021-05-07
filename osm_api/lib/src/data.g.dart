// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapData _$MapDataFromJson(Map<String, dynamic> json) {
  return MapData(
    elements: (json['elements'] as List<dynamic>)
        .map((e) => Element.fromJson(e as Map<String, dynamic>))
        .toList(),
    user: (json['user'] as List<dynamic>?)
        ?.map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MapDataToJson(MapData instance) => <String, dynamic>{
      'elements': instance.elements,
      'user': instance.user,
    };

Member _$MemberFromJson(Map<String, dynamic> json) {
  return Member(
    type: _$enumDecode(_$ElementTypeEnumMap, json['type']),
    ref: json['ref'] as int,
    role: json['role'] as String,
  );
}

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'type': _$ElementTypeEnumMap[instance.type],
      'role': instance.role,
      'ref': instance.ref,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ElementTypeEnumMap = {
  ElementType.node: 'node',
  ElementType.way: 'way',
  ElementType.relation: 'relation',
};

Element _$ElementFromJson(Map<String, dynamic> json) {
  return Element(
    type: _$enumDecode(_$ElementTypeEnumMap, json['type']),
    id: json['id'] as int,
    timestamp: DateTime.parse(json['timestamp'] as String),
    version: json['version'] as int,
    changeset: json['changeset'] as int,
    user: json['user'] as String,
    uid: json['uid'] as int,
    visible: json['visible'] as bool? ?? false,
    tags: (json['tags'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(k, e as String),
        ) ??
        {},
    raw_lat: (json['lat'] as num?)?.toDouble() ?? 0,
    raw_lon: (json['lon'] as num?)?.toDouble() ?? 0,
    raw_members: (json['members'] as List<dynamic>?)
            ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    raw_nodes:
        (json['nodes'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
  );
}

Map<String, dynamic> _$ElementToJson(Element instance) => <String, dynamic>{
      'type': _$ElementTypeEnumMap[instance.type],
      'id': instance.id,
      'version': instance.version,
      'changeset': instance.changeset,
      'uid': instance.uid,
      'timestamp': instance.timestamp.toIso8601String(),
      'user': instance.user,
      'visible': instance.visible,
      'tags': instance.tags,
      'lat': instance.raw_lat,
      'lon': instance.raw_lon,
      'nodes': instance.raw_nodes,
      'members': instance.raw_members,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    display_name: json['display_name'] as String,
    account_created: DateTime.parse(json['account_created'] as String),
    description: json['description'] as String,
    contributor_terms: Map<String, bool>.from(json['contributor_terms'] as Map),
    roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
    changesets: Map<String, int>.from(json['changesets'] as Map),
    traces: Map<String, int>.from(json['traces'] as Map),
    blocks: Block.fromJson(json['blocks'] as Map<String, dynamic>),
    languages:
        (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
    messages: Message.fromJson(json['messages'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'account_created': instance.account_created.toIso8601String(),
      'display_name': instance.display_name,
      'description': instance.description,
      'contributor_terms': instance.contributor_terms,
      'roles': instance.roles,
      'changesets': instance.changesets,
      'traces': instance.traces,
      'languages': instance.languages,
      'blocks': instance.blocks,
      'messages': instance.messages,
    };

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    received: Map<String, int>.from(json['received'] as Map),
    sent: Map<String, int>.from(json['sent'] as Map),
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'received': instance.received,
      'sent': instance.sent,
    };

Block _$BlockFromJson(Map<String, dynamic> json) {
  return Block(
    received: Map<String, int>.from(json['received'] as Map),
  );
}

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'received': instance.received,
    };
