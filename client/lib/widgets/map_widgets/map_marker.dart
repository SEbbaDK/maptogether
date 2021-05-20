import 'package:client/quests/quest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapMarker extends Marker {
  Quest quest;

  MapMarker(BuildContext context, this.quest) {
    build(context);
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       // widget(quest);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.pink,
          shape: BoxShape.circle,
        ),
        child: quest.getMarkerSymbol(),
      ),
    );
  }
}