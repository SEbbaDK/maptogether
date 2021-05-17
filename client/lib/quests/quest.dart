import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

abstract class Quest {
  LatLng position;

  osm.Element element;

  Quest(this.position, this.element);

  String getChangesetComment();

  String getQuestion();

  List<String> getPossibilities();
}