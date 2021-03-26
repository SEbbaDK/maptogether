import 'package:flutter/material.dart';
import 'newGroup.dart';

class Groups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(40.0),
      child: Column(

        children: <Widget>[
          Expanded(
            flex: 8,
            child: Text("Groups")
          ),

          Expanded(
            flex: 2,
            child: FlatButton(
              child: Text('Create Group', style: TextStyle(fontSize: 20.0),),
              color: Colors.lightGreen,
              textColor: Colors.white,
              onPressed: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewGroup()));
              },
            ),
          ),

        ],
      ),
    );
  }
}
