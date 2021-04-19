import 'package:flutter/material.dart';
import 'package:ui/widgets/app_bar.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MapTogetherAppBar(
        title: "Settings",
        actionButtons: [],
      ),
      body: Container(
        child: Center(
          child: Text('Settings',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
