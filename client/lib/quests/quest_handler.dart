import 'package:client/quests/bench_quests/backrest_bench_quest.dart';
import 'package:client/quests/building_quests/building_type_quest.dart';
import 'package:client/quests/quest.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

class QuestHandler extends ChangeNotifier {
  osm.Api api;

  List<Quest> quests = [];

  // Finding quests within bound
  Future<void> loadQuests(double left, double bottom, double right, double top) async {
    // Fetch elements within bound
    api = osm.Api(
        'id', osm.Auth.getUnauthorizedClient(), osm.ApiEnv.dev('master'));
    List<osm.Element> elements =
        (await api.mapByBox(left, bottom, right, top)).elements;

    // Finds backrestBenchQuests
    List<Quest> backrestBenchQuest = _getBackrestBenchQuests(elements);
    backrestBenchQuest.forEach((backrestBenchQuest) {
      if (!this.quests.contains(backrestBenchQuest)) {
        this.quests.add(backrestBenchQuest);
      }
    });

    // Finds buildingTypeQuests
    List<Quest> buildingTypeQuests = _getBuildingTypeQuests(elements);
    buildingTypeQuests.forEach((buildingTypeQuest) {
      if (!this.quests.contains(buildingTypeQuest)) {
        this.quests.add(buildingTypeQuest);
      }
    });

    notifyListeners();
  }

  void removeQuest(Quest quest) {
    this.quests.remove(quest);
    notifyListeners();
  }

  bool _hasKeyValue(osm.Element element, String key, String value) {
    for (var k in element.tags.keys) {
      if (k == key && element.tags[k] == value) {
        return true;
      }
    }
    return false;
  }

  bool _hasTag(osm.Element element, String tag) {
    return (element.tags.containsKey(tag));
  }

  List<Quest> _getBackrestBenchQuests(List<osm.Element> elements) {
    List<osm.Element> benchElements = elements
        .where((element) => _hasKeyValue(element, 'amenity', 'bench'))
        .where((element) => !_hasTag(element, 'backrest'))
        .where((element) => element.type == osm.ElementType.node)
        .toList();

    List<Quest> benchQuests = [];
    benchElements.forEach((element) {
      benchQuests
          .add(BackrestBenchQuest(LatLng(element.lat, element.lon), element));
    });
    return benchQuests;
  }

  List<Quest> _getBuildingTypeQuests(List<osm.Element> elements) {
    List<osm.Element> buildingElements = elements
        .where((element) =>
            _hasKeyValue(element, 'building', 'yes') &&
            element.type == osm.ElementType.way)
        .toList();

    List<Quest> buildingQuests = [];

    for (var buildingElement in buildingElements) {
      double averageLat = 0, averageLong = 0;

      for (int nodeId in buildingElement.nodes) {
        for (osm.Element e in elements) {
          if (e.id == nodeId && e.type == osm.ElementType.node) {
            averageLat += e.lat;
            averageLong += e.lon;
          }
        }
      }
      averageLat /= buildingElement.nodes.length;
      averageLong /= buildingElement.nodes.length;

      buildingQuests.add(
          BuildingTypeQuest(LatLng(averageLat, averageLong), buildingElement));
    }
    return buildingQuests;
  }
}
