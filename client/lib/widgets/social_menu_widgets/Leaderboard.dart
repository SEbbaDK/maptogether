import 'package:client/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:client/database.dart';
import 'package:provider/provider.dart';

import 'User.dart';

class LeaderBoard{
  String name;
  List<User> users;

  LeaderBoard(this.name, this.users){
    users.sort((a, b) => b.total.compareTo(a.total));
  }
}


class LeaderBoardView extends StatelessWidget{
  int leaderboardIndex;
  LeaderBoardView({Key key, @required this.leaderboardIndex}) : super(key: key);

  @override
  Widget build(BuildContext context){
    var curLeaderboard = context.watch<DummyDatabase>().leaderboards[leaderboardIndex];
    //we sort the list whenever we open the list, such that it is in correct order in case of updates to the database
    curLeaderboard.users.sort((a, b) => b.total.compareTo(a.total));

    return Scaffold(
      appBar: MapTogetherAppBar(
        title: "Leaderboard for " + curLeaderboard.name,
        actionButtons: [],
      ),
      body: Center(
        child: Container(
        margin: EdgeInsets.all(40.0),
        child: Column(
          children: <Widget>[
          Expanded(
          child: ListView.builder(
              itemCount: curLeaderboard.users.length,
              itemBuilder: (context, index){
                return Card(
                  child: ListTile(
                    title: Text("#"
                        + (index+1).toString()
                        + " "
                        + curLeaderboard.users[index].name
                        + " : "
                        + curLeaderboard.users[index].total.toString()
                        + " points"),

                    leading: CircleAvatar(
                      backgroundImage:
                        AssetImage('assets/${curLeaderboard.users[index].pfp}'),

                    ),
                  ),
                );
              }),
          ),
            TextButton(
                onPressed: (){
                  for(int x = 0; x < curLeaderboard.users.length; x++)
                    if(curLeaderboard.users[x].name == context.read<DummyDatabase>().currentUserName)
                      Provider.of<DummyDatabase>(context, listen: false).givePoints(10);
                  curLeaderboard.users.sort((a, b) => b.total.compareTo(a.total));
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

