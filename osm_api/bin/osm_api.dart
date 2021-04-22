import "package:osm_api/osm_api.dart";

void main() {
  var api = OsmApi();
  api.mapByBox(1.001, 1.001, 1.01, 1.01).then((map) {
    print(map.elements.length);
    print(map.elements.where((e) => e.isNode).map((v) => v.toJson()));
  });
}
