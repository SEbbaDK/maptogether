import 'package:flutter/material.dart';
import 'package:osm_api/osm_api.dart' as osm;
import 'package:latlong/latlong.dart';
import 'package:quiver/core.dart';

abstract class Quest {
  osm.Element element;
  LatLng position = LatLng(0,0);

  Quest(this.element);

  Widget icon();

  String changesetComment();

  String question();

  Future<void> solve(osm.Api api, String possibility);

  @override
  bool operator ==(Object that) {
    return that is Quest &&
        this.element.type == that.element.type &&
        this.element.id == that.element.id &&
        this.question() == that.question();
  }

  // Inspired by this: https://stackoverflow.com/questions/20577606/whats-a-good-recipe-for-overriding-hashcode-in-dart
  @override
  int get hashCode {
    return hash3(element.type.hashCode, element.id.hashCode, question());
  }
}
