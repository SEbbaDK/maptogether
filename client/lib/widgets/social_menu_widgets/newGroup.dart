import 'package:flutter/material.dart';
import 'package:client/widgets/app_bar.dart';

class NewGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: MapTogetherAppBar(
            title: 'Create New Group',
            actionButtons: [],
          ),
          body: Center(child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('Create Group', style: TextStyle(fontSize: 20.0),),
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          ]
          ))
      );
  }
}