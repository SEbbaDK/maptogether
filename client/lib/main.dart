import 'package:client/location_handler.dart';
import 'package:client/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import 'database.dart';

void main() => runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => DummyDatabase()),
        ChangeNotifierProvider(create: (_) => LocationHandler()),
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
