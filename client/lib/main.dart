import 'package:client/location_handler.dart';
import 'package:client/quests/quest_finder.dart';
import 'package:client/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database.dart';

void main() => runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => DummyDatabase()),
        ChangeNotifierProvider(create: (_) => LocationHandler()),
        ChangeNotifierProvider(create: (_) => QuestFinder()),
      ], child: MyApp()),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${context.watch<DummyDatabase>().currentUserName}',
      theme: ThemeData(
          primaryColor: Colors.green,
          primarySwatch: Colors.green,
          colorScheme:
              ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen)),
      home: MapScreen(),
    );
  }
}
