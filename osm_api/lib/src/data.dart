import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class MapData {
  final List<Element> elements;

  MapData({required this.elements});
  factory MapData.fromJson(Map<String, dynamic> json) =>
      _$MapDataFromJson(json);
  Map<String, dynamic> toJson() => _$MapDataToJson(this);
}

enum ElementType { node, way, relation }
String elementTypeString(ElementType t) =>
    t.toString().toLowerCase().split(".").last;

@JsonSerializable()
class Member {
  final ElementType type;
  final String role;
  final int ref;

  Member({required this.type, required this.ref, required this.role});

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}

@JsonSerializable()
class Element {
  final ElementType type;
  final int id, version, changeset, uid;
  final DateTime timestamp;
  final String user;
  @JsonKey(defaultValue: false)
  final bool visible;

  @JsonKey(defaultValue: {})
  Map<String, String> tags;

  @JsonKey(name: "lat", defaultValue: 0)
  final double raw_lat;
  @JsonKey(name: "lon", defaultValue: 0)
  final double raw_lon;

  @JsonKey(name: "nodes", defaultValue: [])
  final List<int> raw_nodes;

  @JsonKey(name: "members", defaultValue: [])
  final List<Member> raw_members;

  double get lat {
    if (type != ElementType.node)
      throw Exception("Lattitude only available on node elements");
    else
      return raw_lat;
  }

  double get lon {
    if (type != ElementType.node)
      throw Exception("Lontitude only available on node elements");
    else
      return raw_lon;
  }

  List<int> get nodes {
    if (type != ElementType.way)
      throw Exception("Nodes only available for way elements");
    else
      return raw_nodes;
  }

  List<Member> get members {
    if (type != ElementType.relation)
      throw Exception("Member only available for relation elements");
    else
      return raw_members;
  }

  bool get isNode => type == ElementType.node;
  bool get isWay => type == ElementType.way;
  bool get isRelation => type == ElementType.relation;

  Element({
    required this.type,
    required this.id,
    required this.timestamp,
    required this.version,
    required this.changeset,
    required this.user,
    required this.uid,
    required this.visible,
    required this.tags,
    required this.raw_lat,
    required this.raw_lon,
    required this.raw_members,
    required this.raw_nodes,
  });

  factory Element.fromJson(Map<String, dynamic> json) =>
      _$ElementFromJson(json);
  Map<String, dynamic> toJson() => _$ElementToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final DateTime account_created;
  final String display_name, description;
  final Map<String, bool> contributor_terms;
  final List<String> roles;
  final Map<String, int> changesets, traces;
  final List<String> languages;
  final Block blocks;
  final Message messages;


  User({
      required this.id,
      required this.display_name,
      required this.account_created,
      required this.description,
      required this.contributor_terms,
      required this.roles,
      required this.changesets,
      required this.traces,
      required this.blocks,
      required this.languages,
      required this.messages,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}

@JsonSerializable()
class Message{

  final Map<String, int> received, sent;


  Message({required this.received, required this.sent});

    factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

}

@JsonSerializable()
class Block{
  final Map<String, int> received;

  Block({required this.received});

      factory Block.fromJson(Map<String, dynamic> json) =>
      _$BlockFromJson(json);
  Map<String, dynamic> toJson() => _$BlockToJson(this);
  
}


