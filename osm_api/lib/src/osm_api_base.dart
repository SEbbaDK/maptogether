import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_data.dart' as data;

class OsmApi {
  static final String _url =
      "https://master.apis.dev.openstreetmap.org/api/0.6/";

  Future<http.Response> _get(String path) =>
      http.get(Uri.parse(_url + path), headers: {"Accept": "application/json"});

  Future<data.MapData> mapByBox(
      double left, double bottom, double right, double top) async {
    var response = await _get("map?bbox=${left},${bottom},${right},${top}");
    if (response.statusCode != 200) throw response.body;
    var json = jsonDecode(response.body);
    return data.MapData.fromJson(json);
  }
}
