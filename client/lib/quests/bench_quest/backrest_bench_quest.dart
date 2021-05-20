import 'package:client/quests/simple_tag_quest.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

class BackrestBenchQuest extends SimpleTagQuest {
  BackrestBenchQuest(LatLng position, osm.Element element)
      : super(position, element);

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

  @override
  Map<String, String> possibilitiesToTags() {
    return {"Yes": "yes", "No": "no"};
  }

  @override
  Future<void> solve(osm.Api api, String possibility) async {
    int changeSetId = await api.createChangeset(this.getChangesetComment());

    // add the new tag to the tag-map
    this.element.tags['backrest'] = possibility;

    int nodeId = await api.updateNode(
        this.element.id,
        changeSetId,
        this.position.latitude,
        this.position.longitude,
        this.element.version,
        this.element.tags);

    api.closeChangeset(changeSetId);
  }
}
