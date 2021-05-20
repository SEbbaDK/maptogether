import 'package:client/quests/quest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapMarker extends Marker {
  Quest quest;

  LatLng position;

  MapMarker(BuildContext context, this.quest, this.position) {
    build(context);
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink,
        shape: BoxShape.circle,
      ),
      child: quest.getMarkerSymbol(),
    );
  }
}

/*

onPressed: () async {
    LoginHandler loginHandler = context.read<LoginHandler>();
    QuestHandler questHandler = context.read<QuestHandler>();
    LocationHandler locationHandler = context.read<LocationHandler>();

    if (!loginHandler.loggedIntoOSM())
    requestLogin(context, social: false);
    else
    questHandler
        .answerBenchQuest(loginHandler, locationHandler, questHandler, quest, i)
        .then((value) => Navigator.pop(context));
    },

 */
