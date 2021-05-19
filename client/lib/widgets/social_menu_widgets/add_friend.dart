import 'package:flutter/material.dart';
import 'package:client/widgets/app_bar.dart';
import 'friends.dart';
import 'package:provider/provider.dart';

class AddFriend extends StatelessWidget {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MapTogetherAppBar(
          title: 'Follow New',
          actions: [],
        ),
        body: Center(child: Column(children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 50),
                    child: Text(
                      'Find via Username',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    ),
                ),

                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),

                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.green
                      ),
                      child: Text('Follow'),
                      onPressed: () {
                        //Add friend to backend for user here
                        print("FOLLOW SOMEONE");
                        print(nameController.text);
                        Navigator.pop(context);
                      },
                    )),

              ],
            ),
          ),
        ]
        ))
    );
  }
}
