import 'package:client/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class NewGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MapTogetherAppBar(
          title: 'Create New Group',
          actions: [],
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.all(25),
            child: Container(
              color: Colors.lightGreen,
              child: TextButton(
                child: Text(
                  'Create Group',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
          ),
        ])));
  }
}
