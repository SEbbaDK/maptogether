import 'package:client/quests/simple_tag_quest.dart';
import 'package:flutter/material.dart';
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
        'Dormitory': 'dormitory',
        'Farm': 'farm',
        'Ger': 'ger',
        'Hotel': 'hotel',
        'House': 'house',
        'Houseboat': 'houseboat',
        'Residential': 'residential',
        'Semidetached house': 'semidetached_house',
        'Static caravan': 'static_caravan',
      };

  @override
  Future<void> solve(osm.Api api, String possibility) async {
    int changeSetId = await api.createChangeset(this.getChangesetComment());

    // add the new tag to the tag-map
    print(this.element.tags['building']);
    this.element.tags['building'] = possibility;

    int nodeId = await api.updateWay(
      this.element.id,
      changeSetId,
      this.element.tags,
      this.element.version,
      this.element.nodes,
    );

    api.closeChangeset(changeSetId);
  }
}
