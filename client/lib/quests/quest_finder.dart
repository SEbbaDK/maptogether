import 'package:client/quests/bench_quest/backrest_bench_quest.dart';
import 'package:client/quests/quest.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

class QuestFinder extends ChangeNotifier {
  osm.Api api;

  List<Quest> quests = [];

  QuestFinder() {
    getBenchQuests();
  }

  bool _isBench(osm.Element element) {
    return (element.tags.containsKey('amenity') &&
        element.tags.containsValue('bench'));
  }

  bool _hasTagBenchBackrest(osm.Element element) {
    return !(element.tags.containsKey('backrest'));
  }

  void getBenchQuests() async {
    api = osm.Api(
        'id', osm.Auth.getUnauthorizedClient(), osm.ApiEnv.production());
    List<osm.Element> elements =
        (await api.mapByBox(11.58, 55.90, 11.6314, 55.9259)).elements;

    List<Quest> benchQuests = [];
    List<osm.Element> benchElements = elements
        .where((element) => _isBench(element))
        .where((element) => _hasTagBenchBackrest(element))
        .toList();

    benchElements.forEach((element) {
      benchQuests.add(BackrestBenchQuest(LatLng(element.lat, element.lon), element));
    });

    print(benchElements);
    quests.addAll(benchQuests);
  }
}

//void main() {
//  QuestFinder questFinder = QuestFinder();
//  questFinder.getBenchQuests();
//}
