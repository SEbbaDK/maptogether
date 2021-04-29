import 'package:client/screens/map_screen.dart';
import 'package:client/widgets/social_menu_widgets/Leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (_) => DummyDatabase()),
    ],
    child: MaterialApp(
      title: '${context.watch<DummyDatabase>().currentUserName}',
      theme: ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen)
      ),
      home: MapScreen(),
    );
  }
}