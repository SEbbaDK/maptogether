import 'package:client/quests/simple_tag_quest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

class BuildingTypeQuest extends SimpleTagQuest {
  BuildingTypeQuest(LatLng position, osm.Element element)
      : super(position, element);

  @override
  String getQuestion() => "What type of building is this?";

  @override
  String getChangesetComment() => "Added buildingtype tag to a building";

  @override
  Widget getMarkerSymbol() => Icon(Icons.house);

  @override
  Map<String, String> possibilitiesToTags() => {
        'Apartments': 'apartments',
        'Bungalow': 'bungalow',
        'House': 'house',
      };

  @override
  Future<void> solve(osm.Api api, String possibility) {
    // TODO: implement solve
    throw UnimplementedError();
  }
}
