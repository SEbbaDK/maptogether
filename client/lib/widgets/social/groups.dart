import 'package:flutter/material.dart';
import 'package:client/widgets/social/create_group.dart';

class Groups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(40.0),
      child: Column(
        children: <Widget>[
          Expanded(flex: 10, child: Text("Groups")),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.lightGreen,
              child: TextButton(
                child: Text(
                  'Create Group',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateGroup()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
