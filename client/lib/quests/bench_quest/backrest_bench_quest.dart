import 'package:client/quests/quest.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

class BackrestBenchQuest extends Quest {

  BackrestBenchQuest(LatLng position, osm.Element element) : super(position, element);

  void appyAnswer(BenchBackrestAnswer) {}

  @override
  List<String> getPossibilities() {
    return ['Yes', 'No'];
  }

  @override
  getQuestion() {
    return 'Does the bench have a backrest?';
  }

}