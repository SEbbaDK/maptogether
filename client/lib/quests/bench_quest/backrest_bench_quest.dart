import 'package:client/quests/quest.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

enum BenchBackrestAnswer {no, yes}

class BackrestBenchQuest extends Quest {

  BackrestBenchQuest(LatLng position, osm.Element element) : super(position, element);

  void appyAnswer(BenchBackrestAnswer) {}

  @override
  List<String> getPossibilities() {
    List<String> posibillities = [
      'Yes', 'No',
    ];
    return posibillities;
  }

  @override
  getQuestion() {
    return 'Does the bench have a backrest?';
  }

}