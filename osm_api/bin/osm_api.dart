import 'dart:convert';
import 'dart:io';

import 'package:osm_api/osm_api.dart';
import 'package:args/args.dart';

var usage = '''
USAGE:
  osm_api COMMAND [PARAMS]

COMMANDS:
  help
    Show this menu

  map-by-box <left> <bottom> <right> <top>
    Get the data in the bounding box (params are latlong coords)

  create-changeset <comment> <createdBy>
    Create a changeset and return api
    comment:   The comment for the changeset
    createdBy: The program creating this changeset
''';

void error(String message) {
  stderr.write(message + '\n');
  exit(1);
}

Future<dynamic> command(String command, List<String> args) {
  var api = OsmApi();

  switch (command) {
    case "help":
      print(usage);
      exit(0);
      break;

    case "map-by-box":
      {
        if (args.length != 4) error('map-by-box takes 4 parameters');
        var vals = args.map((a) => double.parse(a)).toList();
        return Function.apply(api.mapByBox, vals);
      }

    case "create-changeset":
      {
        if (args.length != 2) error('create-changeset takes 2 parameters');
        return api.createChangeset(comment: args[0], createdBy: args[1]);
      }

      default: error('Unsupported command: $command'); break;
  }

  throw 'cannot happen';
}

int main(List<String> args) {
  if (args.isEmpty) error('No argument given\n' + usage);

  var c = args[0];
  var a = (args.length == 1) ? <String>[] : args.skip(1).toList();
  command(c, a).then((r) => print(jsonEncode(r.toJson())));
  return 0;
}
