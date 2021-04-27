import 'package:client/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:client/database.dart';

import 'User.dart';

class LeaderBoard extends ChangeNotifier{
  String name;
  List<User> users;

  LeaderBoard(this.name, this.users){
    users.sort((a, b) => b.total.compareTo(a.total));
  }

  void reSort(){
    users.sort((a, b) => b.total.compareTo(a.total));
    notifyListeners();
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
        child: Column(
          children: <Widget>[
          Expanded(
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
          ),
            TextButton(
                onPressed: (){
                  for(int x = 0; x < widget.leaderBoard.users.length; x++)
                    if(widget.leaderBoard.users[x].name == currentUserName)
                      widget.leaderBoard.users[x].total += 10;
                  widget.leaderBoard.users.sort((a, b) => b.total.compareTo(a.total));
                  setState(() {

                  });
                },
                child: Text("+++++")
            )
          ]
        )
        )
      )
    );
  }
}

