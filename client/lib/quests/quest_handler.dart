import 'package:client/location_handler.dart';
import 'package:client/login_handler.dart';
import 'package:client/quests/bench_quest/backrest_bench_quest.dart';
import 'package:client/quests/quest.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

class QuestHandler extends ChangeNotifier {
  osm.Api api;

  List<Quest> quests = [];

  bool _isBench(osm.Element element) {
    return (element.tags.containsKey('amenity') &&
        element.tags.containsValue('bench'));
  }

  bool _hasTagBenchBackrest(osm.Element element) {
    return !(element.tags.containsKey('backrest'));
  }

  Future<List<Quest>> getBenchQuests(
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

  Future<List<Quest>> getQuests(double left, double bottom, double right, double top) async {
    List<Quest> quests = await getBenchQuests(left, bottom, right, top);
    notifyListeners();
    this.quests = quests;
  }

  void removeQuest(Quest quest) {
    this.quests.remove(quest);
    notifyListeners();
  }

}

// TODO: Slet det her
/*
  Future<void> answerBenchQuest(
    LoginHandler loginHandler,
    LocationHandler locationHandler,
    QuestHandler questFinder,
    BackrestBenchQuest quest,
    int possibilityNumber,
  ) async {
    var api = loginHandler.osmApi();

    int changeSetId = await api.createChangeset(quest.getChangesetComment());

    // add the new tag to the tag-map
    quest.element.tags['backrest'] =
        quest.getPossibilities()[possibilityNumber].toString();

    int nodeId = await api.updateNode(
        quest.element.id,
        changeSetId,
        quest.position.latitude,
        quest.position.longitude,
        quest.element.version,
        quest.element.tags);

    api.closeChangeset(changeSetId);
    print('Selected answer: ' +
        quest.getPossibilities()[possibilityNumber].toString());

    questFinder.getQuests(
        locationHandler.mapController.bounds.west,
        locationHandler.mapController.bounds.south,
        locationHandler.mapController.bounds.east,
        locationHandler.mapController.bounds.north);
  }
 */