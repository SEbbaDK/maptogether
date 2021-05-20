import 'package:client/login_handler.dart';
import 'package:client/quests/quest.dart';
import 'package:client/quests/simple_tag_quest.dart';
import 'package:client/quests/simple_tag_quest_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:osm_api/osm_api.dart' as osm;
import 'package:provider/provider.dart';

class QuestPopUp extends StatelessWidget {
  QuestPopUp(this._quest);

  final Quest _quest;

  @override
  Widget build(BuildContext context) {
    if (_quest is SimpleTagQuest) {
      return SimpleTagQuestPopUp(
          _quest, context.read<LoginHandler>().osmApi());
    } else {
      throw 'PopUp buttons not implemented for this quest type';
    }
  }
}