import 'package:client/quests/quest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapMarker extends Marker {
  MapMarker(BuildContext context, Quest quest)
      : super(builder: (c) => widget(c, quest));

  static Widget widget(BuildContext context, Quest quest) {
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
