import 'package:client/quests/bench_quests/backrest_bench_quest.dart';
import 'package:client/quests/quest.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

class QuestHandler extends ChangeNotifier {
  osm.Api api;

  List<Quest> quests = [];

  Future<List<Quest>> getQuests(
      double left, double bottom, double right, double top) async {
    // Finding quests within bound
    List<Quest> backrestBenchQuest =
        await _getBackrestBenchQuests(left, bottom, right, top);

    backrestBenchQuest.forEach((backrestBenchQuest) {
      if (!this.quests.contains(backrestBenchQuest)) {
        this.quests.add(backrestBenchQuest);
      }
    });

    notifyListeners();
  }

  void removeQuest(Quest quest) {
    this.quests.remove(quest);
    notifyListeners();
  }

  bool _isBench(osm.Element element) {
    return (element.tags.containsKey('amenity') &&
        element.tags.containsValue('bench'));
  }

  bool _hasTagBenchBackrest(osm.Element element) {
    return !(element.tags.containsKey('backrest'));
  }

  Future<List<Quest>> _getBackrestBenchQuests(
      double left, double bottom, double right, double top) async {
    api = osm.Api(
        'id', osm.Auth.getUnauthorizedClient(), osm.ApiEnv.dev('master'));
    List<osm.Element> elements =
        (await api.mapByBox(left, bottom, right, top)).elements;

    List<Quest> benchQuests = [];
    List<osm.Element> benchElements = elements
        .where((element) => _isBench(element))
        .where((element) => _hasTagBenchBackrest(element))
        .toList();

    benchElements.forEach((element) {
      benchQuests
          .add(BackrestBenchQuest(LatLng(element.lat, element.lon), element));
    });
    return benchQuests;
  }
}
