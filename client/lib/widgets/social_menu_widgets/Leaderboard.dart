import 'package:client/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:client/database.dart';
import 'package:provider/provider.dart';

import 'User.dart';

class LeaderBoard with ChangeNotifier{
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


class LeaderBoardView extends StatelessWidget{
  LeaderBoard leaderBoard;

  LeaderBoardView({Key key, @required this.leaderBoard}) : super(key: key);

  void _reSort(BuildContext context){
    Provider.of<LeaderBoard>(context, listen: false).reSort();
  }
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
        child: Column(
          children: <Widget>[
          Expanded(
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
          ),
            TextButton(
                onPressed: (){
                  for(int x = 0; x < leaderBoard.users.length; x++)
                    if(leaderBoard.users[x].name == currentUserName)
                      leaderBoard.users[x].total += 10;
                  leaderBoard.users.sort((a, b) => b.total.compareTo(a.total));
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

