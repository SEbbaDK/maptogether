import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

import 'package:client/quests/simple_tag_quest.dart';
import 'package:client/quests/quest_finder.dart';
import 'package:client/quests/quest.dart';

class BackrestBenchQuestFinder implements QuestFinder {
  @override
  Quest construct(osm.Element e) => BackrestBenchQuest(e);
    
  @override
  bool applicable(osm.Element e) =>
    e.isNode &&
    e.tags['amenity'] == 'bench' &&
    !e.tags.containsKey('backrest');
}

class BackrestBenchQuest extends SimpleTagQuest {
  BackrestBenchQuest(osm.Element element) : super(element);

  @override
  String tag() => 'backrest';

  @override
  question() => 'Does the bench have a backrest?';

  @override
  String changesetComment() => 'Added backrest tag for a bench';

  @override
  Widget icon() => Icon(Icons.airline_seat_recline_normal_sharp);

  @override
  Map<String, String> possibilitiesToTags() => {'Yes': 'yes', 'No': 'no'};
}
