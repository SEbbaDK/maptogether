import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

abstract class Quest {
  LatLng position;

  osm.Element element;

  Quest(this.position, this.element);

  Widget getMarkerSymbol();

  String getChangesetComment();

  String getQuestion();

  List<String> getPossibilities();

  Future<void> solve(osm.Api api, String possibility);

  bool operator ==(that) =>
      that is Quest &&
      that.position == this.position &&
      that.getQuestion() == this.getQuestion();

  @override
  // TODO: Is this correct?
  int get hashCode => position.hashCode ^ element.hashCode;
}
