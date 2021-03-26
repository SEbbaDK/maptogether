import 'package:flutter/material.dart';
import 'package:client/widgets/app_bar.dart';
import 'friends.dart';

class NewFriend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MapTogetherAppBar(
          title: 'Add Friend',
          actionButtons: [],
        ),
        body: Center(child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.all(25),
            child: Column(
              children: <Widget>[
                Expanded(child: Text("Add Friend Menu")),
                Expanded(child: FlatButton(
                  padding: const EdgeInsets.all(10),
                  child: Text("Add Friend", style: TextStyle(fontSize: 20.0),),
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                  onPressed: (){}
                ))
              ],
            ),
          ),
        ]
        ))
    );
  }
}