import 'package:osm_api/osm_api.dart';
import 'package:client/quests/quest.dart';

abstract class QuestFinder {
  bool applicable(Element e);
  Quest construct(Element e);
}
