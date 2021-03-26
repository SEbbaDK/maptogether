import 'package:client/widgets/app_bar.dart';
import 'package:client/widgets/social_menu_widgets/friends.dart';
import 'package:client/widgets/social_menu_widgets/groups.dart';
import 'package:client/widgets/social_menu_widgets/history.dart';
import 'package:client/widgets/social_menu_widgets/leaderboards.dart';
import 'package:client/widgets/social_menu_widgets/newFriend.dart';
import 'package:client/widgets/social_menu_widgets/user_overview.dart';
import 'package:flutter/material.dart';

class Friend{
  String name; //name of user
  int score; //users score
  double cockLength; //users penile length
  String pfp; //profile picture of user

  Friend(String n, int s, double c, String p){
    name = n;
    score = s;
    cockLength = c;
    pfp = p;
  }
}

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {

  List<Friend> friends = [
    Friend("Thomas", 24, 28.0, "kid.png"),
    Friend("Hartvig", 23, 34.0, "anime.png"),
    Friend("Simon", 24, 26.0, "business.png"),
    Friend("Sebastian", 24, 40.0, "clean.png"),
    Friend("Phillip", 23, 1800.0, "arthas.jpg"),
    Friend("Fjeldsø", 23, 3.0, "wolf.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(40.0),
      child: Column(

        children: <Widget>[
          Expanded(
              flex: 1,
              child: Text("Friends")),
          Expanded(
              flex: 7,
              child: ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index){
                    return Card(
                      child: ListTile(
                        onTap: (){},
                        title: Text(friends[index].name),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/${friends[index].pfp}'),
                        ),
                      ),
                    );
                  }
                  )
          ),

          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FlatButton(
                padding: const EdgeInsets.all(10),
                child: Text('Add New Friend', style: TextStyle(fontSize: 20.0),),
                color: Colors.lightGreen,
                textColor: Colors.white,
                onPressed: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewFriend()));
                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}
