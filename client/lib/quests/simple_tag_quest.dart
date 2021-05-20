import 'package:client/quests/quest.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/src/data.dart';

abstract class SimpleTagQuest extends Quest {
  SimpleTagQuest(LatLng position, Element element) : super(position, element);

  @override
  getPossibilities() => possibilitiesToTags().keys;

  Map<String, String> possibilitiesToTags();
}
