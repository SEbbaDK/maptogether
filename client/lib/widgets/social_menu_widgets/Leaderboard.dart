import 'package:client/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'User.dart';

class LeaderBoard{
  String name;
  List<User> users;

  LeaderBoard(this.name, this.users){
    users.sort((a, b) => b.total.compareTo(a.total));
  }
}

class LeaderBoardView extends StatefulWidget{
  LeaderBoard leaderBoard;

  LeaderBoardView({Key key, @required this.leaderBoard}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();

}

class _LeaderBoardState extends State<LeaderBoardView>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: MapTogetherAppBar(
        title: "Leaderboard for " + widget.leaderBoard.name,
        actionButtons: [],
      ),
      body: Center(
        child: Container(
        margin: EdgeInsets.all(40.0),
        child: ListView.builder(
            itemCount: widget.leaderBoard.users.length,
            itemBuilder: (context, index){
              return Card(
                child: ListTile(
                  title: Text("#"
                      + (index+1).toString()
                      + " "
                      + widget.leaderBoard.users[index].name
                      + " : "
                      + widget.leaderBoard.users[index].total.toString()
                      + " points"),
                  leading: CircleAvatar(
                    backgroundImage:
                      AssetImage('assets/${widget.leaderBoard.users[index].pfp}'),
                  ),
                ),
              );
            }),
        )
      )
    );
  }
}

