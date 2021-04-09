import 'package:client/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'User.dart';

class LeaderBoard{
  String name;
  List<User> users;

  LeaderBoard(this.name, this.users){
    users.sort((a, b) => b.total.compareTo(a.total));
  }
}


class LeaderBoardView extends StatelessWidget{
  LeaderBoard leaderBoard;

  LeaderBoardView({Key key, @required this.leaderBoard}) : super(key: key);


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: MapTogetherAppBar(
        title: "Leaderboard for " + leaderBoard.name,
        actionButtons: [],
      ),
      body: Center(
        child: Container(
        margin: EdgeInsets.all(40.0),
        child: ListView.builder(
            itemCount: leaderBoard.users.length,
            itemBuilder: (context, index){
              return Card(
                child: ListTile(
                  title: Text("#"
                      + (index+1).toString()
                      + " "
                      + leaderBoard.users[index].name
                      + " : "
                      + leaderBoard.users[index].total.toString()
                      + " points"),
                  leading: CircleAvatar(
                    backgroundImage:
                      AssetImage('assets/${leaderBoard.users[index].pfp}'),
                  ),
                ),
              );
            }),
        )
      )
    );
  }
}
