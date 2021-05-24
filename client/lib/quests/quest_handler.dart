import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';
import 'package:osm_api/osm_api.dart' as osm;
import 'package:maptogether_api/maptogether_api.dart' as mt;

import 'package:client/quests/bench_quests/backrest_bench_quest.dart';
import 'package:client/quests/building_quests/building_type_quest.dart';
import 'package:client/quests/quest.dart';
import 'package:client/login_handler.dart';

class QuestHandler extends ChangeNotifier {
  osm.Api api;

  Set<Quest> quests = Set();

  final finders = [
    BackrestBenchQuestFinder(),
    BuildingTypeQuestFinder(),
  ];

  Map<int, osm.Element> _nodes = Map();

  LatLng _position(osm.Element e) {
      if (e.isNode)
      	return LatLng(e.lat, e.lon);
      if (e.isWay) {
        double latitude = 0, longitude = 0;
        e.nodes.forEach((id) {
          final n = _nodes[id];
            latitude += n.lat;
            longitude += n.lon;
        });
        var count = e.nodes.length;
        latitude /= count;
        longitude /= count;

        print("Calculated pos: ${latitude}:${longitude}");
        return LatLng(latitude, longitude);
      }
      throw Exception("Only coordinate node and way");
  }

  // Finding quests within bound
  Future<void> loadQuests(
      double left, double bottom, double right, double top) async {
    api = osm.Api(
        'id', osm.Auth.getUnauthorizedClient(), osm.ApiEnv.dev('master'));

    // Fetch elements within bound
    List<osm.Element> elements =
        (await api.mapByBox(left, bottom, right, top)).elements;

    elements.forEach((e) { if (e.isNode) _nodes[e.id] = e; });

    elements.forEach((e) => finders.forEach((f) {
          if (f.applicable(e)) {
              final q = f.construct(e);
              if (!quests.contains(q)) {
                q.position = _position(e);
				quests.add(q);
              }
          }
        }));

    notifyListeners();
  }

  void removeQuest(Quest quest, int changeSet, mt.Api mtapi) async {
    int userId = await api.userId();

    mt.Contribution contribution = mt.Contribution(user_id: userId, type: 1, changeset: changeSet, score: 1, date_time: DateTime.now());

    mtapi.makeContribution(contribution);

    this.quests.remove(quest);
    notifyListeners();
  }
}
