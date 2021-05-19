import 'package:client/location_handler.dart';
import 'package:client/quests/quest_handler.dart';
import 'package:client/screens/map_screen.dart';
import 'package:client/login_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maptogether_api/maptogether_api.dart';


void main() => runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => LoginHandler()),
        ChangeNotifierProvider(create: (_) => LocationHandler()),
        ChangeNotifierProvider(create: (_) => QuestHandler()),
      ], child: MyApp()),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MapTogether',
      theme: ThemeData(
          primaryColor: Colors.lightGreen,
          primarySwatch: Colors.lightGreen,
          colorScheme:
              ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen)),
      home: MapScreen(),
    );
  }
}
