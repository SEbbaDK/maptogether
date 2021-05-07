import 'package:client/quests/quest.dart';
import 'package:latlong/latlong.dart';

enum BenchBackrestAnswer {no, yes}

class BackrestBenchQuest extends Quest {

  BackrestBenchQuest(LatLng position) : super(position);

  void appyAnswer(BenchBackrestAnswer) {}

}