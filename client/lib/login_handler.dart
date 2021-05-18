import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:osm_api/osm_api.dart' as osm;
import 'package:maptogether_api/maptogether_api.dart' as mt;
import 'package:shared_preferences/shared_preferences.dart';

const _ckey = String.fromEnvironment('CKEY');
const _csec = String.fromEnvironment('CSEC');

class LoginHandler extends ChangeNotifier {

  // OSM things
  final _env = osm.ApiEnv.dev('master');
  final osm.Auth _auth = osm.Auth(_ckey, _csec, osm.ApiEnv.dev('master'));
  osm.Api _osmApi = null;
  var _tempToken = null;

	osm.Api osmApi() {
    	if (!loggedIntoOSM())
        	throw Exception('Cannot get OSM Api before logging in');
		if (_osmApi == null)
            _osmApi = osm.Api(
                'MapTogether v0.1.0pre',
                _auth.getClient(_auth.createCredentials(_accessToken(), _accessSecret())),
                _env
            );
		return _osmApi;
	}

  Future<String> loginUrl() async {
    _tempToken = (await _auth.getTemporaryToken()).credentials;
    return _auth.authorizationUrl(_tempToken);
  }

  Future<bool> authorize(String verifier) async {
    final creds = await _auth
        .getAccessToken(_tempToken, verifier)
        .then((res) => res.credentials);
    login(creds.token, creds.tokenSecret);
    return true;
  }


  // MT things
  
  mt.Api _mtApi = null;

  mt.Api mtApi() {
	if (!loggedIntoSocial())
      throw Exception('Cannot get MT Api before logging in');
    if (_mtApi == null)
		_mtApi = mt.Api(_accessToken());
	return _mtApi;
  }


  // General things

  SharedPreferences _prefs = null;

  SharedPreferences prefs() {
    if (_prefs == null)
      throw 'Preferences not loaded yet';
    else
      return _prefs;
  }

  LoginHandler() {
    SharedPreferences.getInstance().then((p) {
      _prefs = p;
      notifyListeners();
    });

    print('CKEY: $_ckey');
    if (_ckey == '')
      throw Exception(
          "You need to specify CKEY and CSEC env vars when building MapTogether");
  }

  String _accessToken() => prefs().getString('accessToken') ?? '';

  String _accessSecret() => prefs().getString('accessSecret') ?? '';

  bool socialOptIn() => prefs().getBool('socialOptIn') ?? false;

  bool loggedIntoOSM() => _accessToken() != '';

  bool loggedIntoSocial() => socialOptIn() && loggedIntoOSM();

  optIn() {
    prefs().setBool('socialOptIn', true);
    osmApi().userId().then((id) =>
 	  mtApi().createUser(id, _accessSecret(), _ckey, _csec).then((_) => 
        notifyListeners()
      )
    );
  }

  login(token, secret) {
    prefs().setString('accessToken', token);
    prefs().setString('accessSecret', secret);
    notifyListeners();
  }

  logout() {
    prefs().setString('accessToken', '');
    prefs().setString('accessSecret', '');
    notifyListeners();
  }
}
