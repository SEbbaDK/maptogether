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

    ApiEnv.production() : _baseUrl ='https://www.openstreetmap.org';

    /// Construct environment from available apis (check https://apis.dev.openstreetmap.org/)
    ApiEnv.dev(String devenv) : _baseUrl = 'https://$devenv.apis.dev.openstreetmap.org';
}

class Auth {
  final platform;
  final ClientCredentials _clientCreds;
  final String _auth;

  Auth(String clientToken, String clientSecret, ApiEnv env)
      : _clientCreds = ClientCredentials(clientToken, clientSecret),
      platform = Platform(env.requestUrl, env.authorizeUrl, env.accessUrl, SignatureMethods.hmacSha1),
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
  final String _programId;
  final http.BaseClient _client;

  Api(this._programId, this._client, this.environment);

  Future<http.Response> _get(String path) => _client
      .get(Uri.parse(environment.apiUrl + path), headers: {'Accept': 'application/json'});

  Future<http.Response> _put(String path, Object data) =>
      _client.put(Uri.parse(environment.apiUrl + path), body: data);

  Future<String> userDetails() => _get('user/details').then((res) {
        if (res.statusCode != 200)
          throw Exception(
              'Getting user details failed with ${res.statusCode}: ${res.body}');
        else
          return res.body;
      });

  Future<data.MapData> mapByBox(
      double left, double bottom, double right, double top) async {
    var response = await _get('map?bbox=$left,$bottom,$right,$top');
    if (response.statusCode != 200) throw response.body;
    var json = jsonDecode(response.body);
    return data.MapData.fromJson(json);
  }

  Future<int> createChangeset(
      {required String comment, required String createdBy}) async {
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
      throw 'Bad response: ${response.body}';
    else
      return id;
  }
}
