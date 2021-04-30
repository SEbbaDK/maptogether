import 'dart:io';
import 'package:osm_api/osm_api.dart' as osm;

void main() async {
  final env = osm.ApiEnv.dev('master');
  final auth = osm.Auth('Consumer Key', 'Consumer Secret', env);

  final creds = (await auth.getTemporaryToken()).credentials;
  print('Visit ${auth.authorizationUrl(creds)}');
  String verifier = stdin.readLineSync() ?? '';
  final client = await auth
      .getAccessToken(creds, verifier)
      .then((res) => auth.getClient(res.credentials));

  final api = osm.Api('AnIdToIdentifyYourClientWith v0.1.0', client, env);
  await api.userDetails().then(print);
}
