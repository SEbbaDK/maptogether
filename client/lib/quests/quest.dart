import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:osm_api/osm_api.dart' as osm;

abstract class Quest {
  osm.Element element;

  Quest(this.element);

  Widget icon();

  String changesetComment();

  String question();

  Future<void> solve(osm.Api api, String possibility);
}
