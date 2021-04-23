import 'package:osm_api/osm_api.dart';
import 'package:test/test.dart';

void main() {
  group('bbox', () {
    OsmApi api = OsmApi();

    setUp(() {});

    test('Fetching is not null', () async {
      var result = (await api.mapByBox(9.5, 56.5, 10, 57)).elements;
      expect(result.length, 50);
    });
  });
}
