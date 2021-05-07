import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:osm_api/osm_api.dart' as osm;

class LoginHandler extends ChangeNotifier {

    final _env = osm.ApiEnv.dev('master');
	final osm.Auth _auth = osm.Auth(String.fromEnvironment('CKEY'), String.fromEnvironment('CSEC'), osm.ApiEnv.dev('master'));
    osm.Api _osmApi = null;
    var _tempToken = null;

	Future<String> loginUrl() async {
    	_tempToken = (await _auth.getTemporaryToken()).credentials;
		return _auth.authorizationUrl(_tempToken);
	}

	void authorize(String verifier) async {
		final creds = await _auth.getAccessToken(_tempToken, verifier).then((res) => res.credentials);
		_osmApi = osm.Api('MapTogether v0.1.0pre', _auth.getClient(creds), _env);
		login(creds.token, creds.tokenSecret);
	}

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
    }

	String _accessToken() => prefs().getString('accessToken') ?? '';
	String _accessSecret() => prefs().getString('accessSecret') ?? '';
    
	bool socialOptIn() => prefs().getBool('socialOptIn') ?? false;

	bool loggedIntoOSM() => _accessToken() != '';

	bool loggedIntoSocial() => socialOptIn() && loggedIntoOSM();

	optIn() {
		prefs().setBool('socialOptIn', true);
		notifyListeners();
	}

	login(token, secret) {
		prefs().setString('accessToken', token);
		prefs().setString('accessSecret', secret);
		notifyListeners();
	}
}
