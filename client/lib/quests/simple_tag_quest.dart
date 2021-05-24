import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

import 'package:client/quests/quest.dart';

abstract class SimpleTagQuest extends Quest {
  SimpleTagQuest(osm.Element element) : super(element);

  String tag();

  Iterable<String> possibilities() => possibilitiesToTags().keys;

  Map<String, String> possibilitiesToTags();

  @override
  Future<int> solve(osm.Api api, String possibility) async {
    int changeSetId = await api.createChangeset(this.changesetComment());

    // add the new tag to the tag-map
    if (!possibilitiesToTags().containsKey(possibility))
      throw Exception("Possibility given does not match the map: $possibility");
    this.element.tags[tag()] = possibilitiesToTags()[possibility];

    if (element.isNode)
      int nodeId = await api.updateNode(
          this.element.id,
          changeSetId,
          element.lat,
          element.lon,
          this.element.version,
          this.element.tags);
    else if (element.isWay)
      int nodeId = await api.updateWay(
        this.element.id,
        changeSetId,
        this.element.tags,
        this.element.version,
        this.element.nodes,
      );
    else
      throw Exception("Only node and way solving works");

    await api.closeChangeset(changeSetId);
    return changeSetId;
  }
}
