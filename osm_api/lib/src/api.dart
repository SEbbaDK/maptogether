import 'dart:convert';
import 'package:http/http.dart' as http;

import 'data.dart' as data;

class OsmApi {
  static final String _url =
      'https://master.apis.dev.openstreetmap.org/api/0.6/';

  Future<http.Response> _get(String path) =>
      http.get(Uri.parse(_url + path), headers: {'Accept': 'application/json'});

  Future<http.Response> _put(String path, Object data) =>
      http.put(Uri.parse(_url + path), body: data);

  Future<data.MapData> mapByBox(
      double left, double bottom, double right, double top) async {
    var response = await _get('map?bbox=$left,$bottom,$right,$top');
    if (response.statusCode != 200) throw response.body;
    var json = jsonDecode(response.body);
    return data.MapData.fromJson(json);
  }

  Future<int> createChangeset({required String comment, required String createdBy}) async {
    var response = await _put('changeset/create', '''
		<osm>
			<changeset>
				<tag k="created_by" v="$createdBy"/>
				<tag k="comment" v="$comment"/>
			</changeset>
		</osm>
	    ''');
    var id = int.tryParse(response.body);
    if (response.statusCode != 200 || id == null)
      throw 'Bad response: $response.body';
    else
      return id;
  }
}
