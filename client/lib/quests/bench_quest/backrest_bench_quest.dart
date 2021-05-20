import 'package:client/quests/quest.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

class BackrestBenchQuest extends Quest {
  BackrestBenchQuest(LatLng position, osm.Element element)
      : super(position, element);

  @override
  List<String> getPossibilities() {
    return ['yes', 'no'];
  }

  @override
  getQuestion() {
    return 'Does the bench have a backrest?';
  }

  @override
  String getChangesetComment() {
    return 'Added backrest tag for a bench';
  }

  @override
  Widget getMarkerSymbol() {
    return Icon(Icons.airline_seat_recline_normal_sharp);
  }
}
