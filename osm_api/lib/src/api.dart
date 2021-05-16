import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:oauth1/oauth1.dart';

import 'data.dart' as data;

class ApiEnv {
  final String _baseUrl;

  String get requestUrl => _baseUrl + '/oauth/request_token';
  String get authorizeUrl => _baseUrl + '/oauth/authorize';
  String get accessUrl => _baseUrl + '/oauth/access_token';
  String get apiUrl => _baseUrl + '/api/0.6/';

  ApiEnv.production() : _baseUrl = 'https://www.openstreetmap.org';

  /// Construct environment from available apis (check https://apis.dev.openstreetmap.org/)
  ApiEnv.dev(String devenv)
      : _baseUrl = 'https://$devenv.apis.dev.openstreetmap.org';
}

class Auth {
  final platform;
  final ClientCredentials _clientCreds;
  final String _auth;

  Auth(String clientToken, String clientSecret, ApiEnv env)
      : _clientCreds = ClientCredentials(clientToken, clientSecret),
        platform = Platform(env.requestUrl, env.authorizeUrl, env.accessUrl,
            SignatureMethods.hmacSha1),
        _auth = env.authorizeUrl;

  Future<AuthorizationResponse> getTemporaryToken() {
    final auth = Authorization(_clientCreds, platform);
    return auth.requestTemporaryCredentials();
  }

  String authorizationUrl(Credentials creds) =>
      '$_auth?oauth_token=${creds.token}&oauth_token_secret=${creds.tokenSecret}';

  Future<AuthorizationResponse> getAccessToken(
      Credentials tempToken, String verifier) {
    final auth = Authorization(_clientCreds, platform);
    return auth.requestTokenCredentials(tempToken, verifier);
  }

  http.BaseClient getClient(Credentials token) =>
      Client(platform.signatureMethod, _clientCreds, token) as http.BaseClient;

  static http.BaseClient getUnauthorizedClient() =>
      http.Client() as http.BaseClient;
}

class Api {
  final ApiEnv environment;

  /// The program specifier ex. "my_client v0.4.0" that are used in changesets
  final String _programId;
  final http.BaseClient _client;

  Api(this._programId, this._client, this.environment);

  Future<http.Response> _get(String path) =>
      _client.get(Uri.parse(environment.apiUrl + path),
          headers: {'Accept': 'application/json'});

  Future<http.Response> _put(String path, [Object? data = null]) =>
      _client.put(Uri.parse(environment.apiUrl + path), body: data);

  String _checkRequest(http.Response res) {
    if (res.statusCode != 200)
      throw Exception('Request failed with ${res.statusCode}: »${res.body}«');
    else
      return res.body;
  }

  data.MapData _decodeMapData(String input) =>
      data.MapData.fromJson(jsonDecode(input));

  int _decodeInt(String input) => int.parse(input,
      onError: (s) =>
          throw Exception('Request should return int but it returned »$s«'));

  /// Get the details of the user whose oauth token is logged in
  Future<String> userDetails() => _get('user/details').then(_checkRequest);

  /// Take a bounding box and return all the elements inside it
  Future<data.MapData> mapByBox(
          double left, double bottom, double right, double top) =>
      _get('map?bbox=$left,$bottom,$right,$top')
          .then(_checkRequest)
          .then(_decodeMapData);

  /// Take a comment and open a new changeset based on it
  Future<int> createChangeset(String comment) => _put('changeset/create', '''
		<osm>
			<changeset>
				<tag k="created_by" v="$_programId"/>
				<tag k="comment" v="$comment"/>
			</changeset>
		</osm>
	    ''').then(_checkRequest).then(_decodeInt);

  /// Close an open changeset
  Future<void> closeChangeset(int id) =>
      _put('changeset/$id/close').then(_checkRequest);

  /// Take an node id and return the node (wrapped in MapData)
  Future<data.MapData> node(int id) =>
      _get('node/$id').then(_checkRequest).then(_decodeMapData);

  /// Take an way id and return the way (wrapped in MapData)
  Future<data.MapData> way(int id) =>
      _get('way/$id').then(_checkRequest).then(_decodeMapData);

  /// Take an relation id and return the relation (wrapped in MapData)
  Future<data.MapData> relation(int id) =>
      _get('relation/$id').then(_checkRequest).then(_decodeMapData);

  String nodeXmlData(int changeset, double lat, double lon, int version, Map<String, String> tags){
    return '''
			<osm>
				<node changeset="$changeset" lat="$lat" lon="$lon" version="$version">
					${stringifyTags(tags)}
				</node>
			</osm>
    		''';
  }

  String wayXmlData(int changeset, Map<String, String> tags, List<int> nodes){
    return '''
        		<osm>
        			<way changeset="$changeset">
        				${stringifyTags(tags)}
        				${stringifyNodes(nodes)}
        			</way>
        		</osm>
    		''';
  }

  String relationXmlData(int changeset, Map<String, String> tags, List<data.Member> members){
    return '''
        		<osm>
        			<relation changeset="${changeset}">
        				${stringifyTags(tags)}
        				${stringifyMembers(members)}
        			</relation>
        		</osm>
    		''';
  }

  /// Create a new node and return its id
  Future<int> createNode(
          int changeset, double lat, double lon, int version, Map<String, String> tags) =>
      _put('node/create', nodeXmlData(changeset, lat, lon, version, tags)).then(_checkRequest).then(_decodeInt);

  /// Create a new way and return its id
  Future<int> createWay(
          int changeset, Map<String, String> tags, List<int> nodes) =>
      _put('way/create', wayXmlData(changeset, tags, nodes) ).then(_checkRequest).then(_decodeInt);

  /// Create a new relation and return its id
  Future<int> createRelation(
          int changeset, Map<String, String> tags, List<data.Member> members) =>
      _put('relation/create', relationXmlData(changeset, tags, members) ).then(_checkRequest).then(_decodeInt);

  /// Update a node
  Future<int> updateNode(
      int id, int changeset, double lat, double lon, int version, Map<String, String> tags) =>
    _put('node/$id', nodeXmlData(changeset, lat, lon, version, tags)).then(_checkRequest).then(_decodeInt);

  /// Update a way
  Future<int> updateWay(
      int id, int changeset, Map<String, String> tags, List<int> nodes) =>
      _put('way/$id', wayXmlData(changeset, tags, nodes) ).then(_checkRequest).then(_decodeInt);

  /// Update a relation
  Future<int> updateRelation(
      int id, int changeset, Map<String, String> tags, List<data.Member> members) =>
      _put('relation/$id', relationXmlData(changeset, tags, members) ).then(_checkRequest).then(_decodeInt);

  String stringifyTags(Map<String, String> map) =>
      map.entries.map((e) => '<tag k="${e.key}" v="${e.value}"/>').join('\n');

  String stringifyNodes(List<int> nodes) =>
      nodes.map((n) => '<nd ref="$n"/>').join('\n');

  String stringifyMembers(List<data.Member> l) => l
      .map((m) =>
          '<member type="${data.elementTypeString(m.type)}" role="${m.role}" ref="${m.ref}"/>')
      .join('\n');
}
