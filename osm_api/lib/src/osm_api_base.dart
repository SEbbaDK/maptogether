// TODO: Put public facing types in this file.

/// Checks if you are awesome. Spoiler: you are.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'osm_api_base.g.dart';

@JsonSerializable()
class MapData {
  final List<Node> elements;

  MapData({required this.elements});
  factory MapData.fromJson(Map<String, dynamic> json) =>
      _$MapDataFromJson(json);
  Map<String, dynamic> toJson() => _$MapDataToJson(this);
}

@JsonSerializable()
class Node {
  final int id, version, changeset, uid;
  final double lat, lon;
  final String timestamp, user;
  final Map<String, String> tags;

  Node(
      {required this.id,
      required this.lat,
      required this.lon,
      required this.timestamp,
      required this.version,
      required this.changeset,
      required this.user,
      required this.uid,
      required this.tags});

  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);
  Map<String, dynamic> toJson() => _$NodeToJson(this);
}

@JsonSerializable()
class Way {
  final int id, version, changeset, uid;
  final String timestamp, user;
  final List<int> nodes;
  final Map<String, String> tags;

  Way(
      {required this.id,
      required this.timestamp,
      required this.version,
      required this.changeset,
      required this.user,
      required this.uid,
      required this.nodes,
      required this.tags});

  factory Way.fromJson(Map<String, dynamic> json) => _$WayFromJson(json);
  Map<String, dynamic> toJson() => _$WayToJson(this);
}

@JsonSerializable()
class Relation {
  final int id, version, changeset, uid;
  final String timestamp, user;
  final List<Map<String, String>> members;
  final Map<String, String> tags;

  Relation(
      {required this.id,
      required this.timestamp,
      required this.version,
      required this.changeset,
      required this.user,
      required this.uid,
      required this.members,
      required this.tags});

  factory Relation.fromJson(Map<String, dynamic> json) =>
      _$RelationFromJson(json);
  Map<String, dynamic> toJson() => _$RelationToJson(this);
}

class OsmApi {
  static final String _url =
      "https://master.apis.dev.openstreetmap.org/api/0.6/";

  Future<http.Response> _get(String path) =>
      http.get(Uri.parse(_url + path), headers: {"Accept": "application/json"});

  Future<MapData> mapByBox(
      double left, double bottom, double right, double top) async {
    var response = await _get("map?bbox=${left},${bottom},${right},${top}");
    if (response.statusCode != 200) throw response.body;
    var json = jsonDecode(response.body);
    return MapData.fromJson(json);
  }
}
