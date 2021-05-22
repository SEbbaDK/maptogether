import 'package:client/quests/bench_quests/backrest_bench_quest.dart';
import 'package:client/quests/building_quests/building_type_quest.dart';
import 'package:client/quests/quest.dart';
import 'package:flutter/material.dart';
import 'package:osm_api/osm_api.dart' as osm;

class QuestHandler extends ChangeNotifier {
  osm.Api api;

  Set<Quest> quests = Set();

  final finders = [
    BackrestBenchQuestFinder(),
    BuildingTypeQuestFinder(),
  ];

  // Finding quests within bound
  Future<void> loadQuests(
      double left, double bottom, double right, double top) async {
    api = osm.Api(
        'id', osm.Auth.getUnauthorizedClient(), osm.ApiEnv.dev('master'));

    // Fetch elements within bound
    List<osm.Element> elements =
        (await api.mapByBox(left, bottom, right, top)).elements;

    elements.forEach((e) => finders.forEach((f) {
          if (f.applicable(e)) quests.add(f.construct(e));
        }));

    notifyListeners();
  }

  void removeQuest(Quest quest) {
    this.quests.remove(quest);
    notifyListeners();
  }
}
