import 'package:client/widgets/social_menu_widgets/newFriend.dart';
import 'package:flutter/material.dart';
import 'User.dart';
import 'package:client/database.dart';
import 'package:provider/provider.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

//TODO: move friends list to a seperate file or server
class _FriendsState extends State<Friends> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(40.0),
      child: Column(
        children: <Widget>[
          Expanded(flex: 1, child: Text("Friends")),
          Expanded(
              flex: 7,
              child: ListView.builder(
                  itemCount: context.watch<DummyDatabase>().following.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onLongPress: () {
                          showModalBottomSheet <void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 100,
                                  color: Colors.orange,
                                  child: Center(
                                    child: TextButton(
                                      child: Text("Remove Friend"),
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: Colors.red
                                      ),
                                      onPressed: (){
                                        print(context.watch<DummyDatabase>().following.removeAt(index));

                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }
                          );
                        },
                        title: Text(context.watch<DummyDatabase>().following[index].name),
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/${context.watch<DummyDatabase>().following[index].pfp}'),
                        ),
                      ),
                    );
                  })),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                color: Colors.lightGreen,
                child: TextButton(
                  child: Text(
                    'Add New Friend',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewFriend()));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
