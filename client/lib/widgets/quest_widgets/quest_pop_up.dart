import 'package:client/login_handler.dart';
import 'package:client/quests/quest.dart';
import 'package:client/quests/simple_tag_quest.dart';
import 'package:client/widgets/quest_widgets/simple_tag_quest_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestPopUp extends StatelessWidget {
  QuestPopUp(this._quest);

  final Quest _quest;

  @override
  Widget build(BuildContext context) {
    if (_quest is SimpleTagQuest) {
      return SimpleTagQuestPopUp(
          _quest, context.watch<LoginHandler>().osmApi());
    } else {
      throw 'PopUp not implemented for this quest type';
    }
  }
}