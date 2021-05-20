import 'package:client/quests/quest.dart';
import 'package:client/quests/simple_tag_quest.dart';
import 'package:flutter/material.dart';

class QuestPopUp extends StatelessWidget {
  QuestPopUp(this._quest);

  final Quest _quest;

  @override
  Widget build(BuildContext context) {
    if (_quest is SimpleTagQuest) {
      return SimpleTagQuestPopUp(_quest);
    } else {
      throw 'PopUp buttons not implemented for this quest type';
    }
  }
}

class SimpleTagQuestPopUp extends StatelessWidget {
  SimpleTagQuestPopUp(SimpleTagQuest quest);


  List<Widget> createButtons() {
    List<Widget> list = [];


  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}