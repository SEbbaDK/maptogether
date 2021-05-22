import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

import 'package:client/quests/quest.dart';
import 'package:client/widgets/quest_widgets/quest_pop_up.dart';

/*
  This class should be used as the default child in Markers for quests
 */
class QuestMarker extends StatelessWidget {
  QuestMarker(this.position, this.quest);

  final LatLng position;
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
        child: quest.icon(),
      ),
    );
  }
}
