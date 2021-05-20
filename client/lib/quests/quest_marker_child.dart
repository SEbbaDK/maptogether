import 'package:client/quests/quest.dart';
import 'package:client/quests/quest_pop_up.dart';
import 'package:flutter/material.dart';

/*
  This class should be used as our default child in Markers for quests
 */
class QuestMarkerChild extends StatelessWidget {
  QuestMarkerChild(this.markerLogo, this.quest);

  final Widget markerLogo;

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => QuestPopUp(quest),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightGreen,
          shape: BoxShape.circle,
        ),
        child: quest.getMarkerSymbol(),
      ),
    );
  }
}
