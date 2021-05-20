import 'package:client/quests/quest.dart';
import 'package:flutter/material.dart';

class QuestMarkerChild extends StatelessWidget {

  QuestMarkerChild(this.markerLogo, this.quest);

  final Widget markerLogo;

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: Colors.pink,
        shape: BoxShape.circle,
      ),
      child: quest.getMarkerSymbol(),
    );
  }
}
