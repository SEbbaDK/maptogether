import 'dart:io';
import 'package:osm_api/osm_api.dart' as osm;

void main() async {
  final auth = osm.Auth('Consumer Key', 'Consumer Secret');

  final creds = (await auth.getTemporaryToken()).credentials;
  print('Visit ${auth.authorisationUrl(creds)}');
  String verifier = stdin.readLineSync() ?? '';
  final client = await auth.getAccessToken(creds, verifier).then((res) => auth.getClient(res.credentials));

  final api = osm.Api('AnIdToIdentifyYourClientWith v0.1.0', client);
  await api.userDetails().then(print);
}
