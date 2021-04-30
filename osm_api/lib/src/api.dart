import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:oauth1/oauth1.dart';

import 'data.dart' as data;

final String
    //_baseUrl = 'https://www.openstreetmap.org',
    _baseUrl = 'https://master.apis.dev.openstreetmap.org',
    _requestUrl = _baseUrl + '/oauth/request_token',
    _authorizeUrl = _baseUrl + '/oauth/authorize',
    _accessUrl = _baseUrl + '/oauth/access_token',
    _apiUrl = _baseUrl + '/api/0.6/';

class Auth {
  static final platform = Platform(
      _requestUrl, _authorizeUrl, _accessUrl, SignatureMethods.hmacSha1);

  final ClientCredentials _clientCreds;
  Auth(String clientToken, String clientSecret) :
      _clientCreds = ClientCredentials(clientToken, clientSecret);
  

  Future<AuthorizationResponse> getTemporaryToken() {
    final auth = Authorization(_clientCreds, platform);
    return auth.requestTemporaryCredentials();
  }

  String authorisationUrl(Credentials creds) =>
      '$_authorizeUrl?oauth_token=${creds.token}&oauth_token_secret=${creds.tokenSecret}';

  Future<AuthorizationResponse> getAccessToken(
      Credentials tempToken, String verifier) {
    final auth = Authorization(_clientCreds, platform);
    return auth.requestTokenCredentials(tempToken, verifier);
  }

  Client getClient(Credentials token) =>
      Client(platform.signatureMethod, _clientCreds, token);
}

class Api {
  final String _programId;
  final Client _client;

  Api(this._programId, this._client);

  Future<http.Response> _get(String path) => _client
      .get(Uri.parse(_apiUrl + path), headers: {'Accept': 'application/json'});

  Future<http.Response> _put(String path, Object data) =>
      _client.put(Uri.parse(_apiUrl + path), body: data);

  Future<String> userDetails() => _get('user/details').then((res) => res.body);

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
