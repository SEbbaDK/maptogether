import 'package:client/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:client/database.dart';
import 'package:maptogether_api/maptogether_api.dart';
import 'package:provider/provider.dart';

import '../../data_fetchers.dart';
import 'User.dart';


class LeaderBoardView extends StatelessWidget{
  int leaderboardIndex;
  String leaderBoardName;
  LeaderboardType type;
  LeaderBoardView({Key key, @required this.leaderBoardName, @required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context){

    return FutureBuilder(
        future: getLeaderboard(type, leaderBoardName),
        builder: (BuildContext context, AsyncSnapshot<Leaderboard> snapshot) {
          if(snapshot.hasData) {
            return Scaffold(
                appBar: MapTogetherAppBar(
                  title: "Leaderboard for " + leaderBoardName,
                  actions: [],
                ),
                body: Center(
                    child: Container(
                        margin: EdgeInsets.all(40.0),
                        child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data.entries.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          title: Text("#"
                                              + (index + 1).toString()
                                              + " "
                                              + snapshot.data.entries[index].user.name
                                              + " : "
                                              + snapshot.data.entries[index].score.toString()
                                              + " points"),

                                          leading: CircleAvatar(
                                            backgroundImage:
                                            AssetImage('assets/business.png'),

                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ]
                        )
                    )
                )
            );
          }
          else if(snapshot.hasError)
            return errorData();

          else {
            return Expanded(
                flex: 14,
                child: waitingLoop());
          }
        }
        );

  }
}
