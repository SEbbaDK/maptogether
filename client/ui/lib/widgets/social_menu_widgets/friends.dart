import 'package:ui/widgets/social_menu_widgets/newFriend.dart';
import 'package:flutter/material.dart';
import 'User.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

//TODO: move friends list to a seperate file or server
class _FriendsState extends State<Friends> {
  List<User> friends = [
    User("Thomas", 24, "kid.png"),
    User("Hartvig", 23,  "anime.png"),
    User("Simon", 24, "business.png"),
    User("Sebastian", 24, "clean.png"),
    User("Phillip", 23, "arthas.png"),
    User("Fjeldsø", 23, "wolf.png"),
  ];

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
                  itemCount: friends.length,
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
                                        print(friends.removeAt(index));

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
                        title: Text(friends[index].name),
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/${friends[index].pfp}'),
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
