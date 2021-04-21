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
  final int id;
  final double lat, lon;

  Node({required this.id, required this.lat, required this.lon});
  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);
  Map<String, dynamic> toJson() => _$NodeToJson(this);
}

class OsmApi {
  static final String _url =
      "https://master.apis.dev.openstreetmap.org/api/0.6/";

  Future<http.Response> _get(String path) =>
      http.get(Uri.parse(_url + path), headers: {"Accept": "application/json"});

  Future<MapData> mapByBox(
      double left, double bottom, double right, double top) async {
    var response = await _get("map?bbox=${left},${bottom},${right},${top}");
    if (response.statusCode != 200)
        throw response.body;
    var json = jsonDecode(response.body);
    return MapData.fromJson(json);
  }
}
