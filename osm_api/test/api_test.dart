import 'package:osm_api/osm_api.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('unauthorized api', () {
    final api = Api('osm_api testing', Auth.getUnauthorizedClient());

    // setUp(() {});

    test('BBox Fetching is not null', () async {
      var result = (await api.mapByBox(9.5, 56.5, 10, 57)).elements;
      expect(result.length, 50);
    });

    test('userDetail cannot be done while unauthorized', () async {
      expect(() async => await api.userDetails(), throwsException);
    });
  });
}
