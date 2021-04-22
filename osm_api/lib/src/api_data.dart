import 'package:json_annotation/json_annotation.dart';

part 'api_data.g.dart';

@JsonSerializable()
class MapData {
  final List<Element> elements;

  MapData({required this.elements});
  factory MapData.fromJson(Map<String, dynamic> json) =>
      _$MapDataFromJson(json);
  Map<String, dynamic> toJson() => _$MapDataToJson(this);
}

enum ElementType { node, way, relation }

@JsonSerializable()
class Element {
  final ElementType type;
  final int id, version, changeset, uid;
  final DateTime timestamp;
  final String user;

  @JsonKey(defaultValue: {})
  Map<String, String> tags;

  @JsonKey(name: "lat", defaultValue: 0)
  final double raw_lat;
  @JsonKey(name: "lon", defaultValue: 0)
  final double raw_lon;

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
    required this.tags,
    required this.raw_lat,
    required this.raw_lon,
  });

  factory Element.fromJson(Map<String, dynamic> json) =>
      _$ElementFromJson(json);
  Map<String, dynamic> toJson() => _$ElementToJson(this);
}
