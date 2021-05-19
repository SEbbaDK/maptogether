import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maptogether_api/maptogether_api.dart';
import 'package:provider/provider.dart';

import 'package:client/widgets/app_bar.dart';
import 'package:client/data_fetchers.dart';

class LeaderBoardView extends StatelessWidget {
  int leaderboardIndex;
  String leaderBoardName;
  LeaderboardType type;
  LeaderBoardView(
      {Key key, @required this.leaderBoardName, @required this.type})
      : super(key: key);

  Widget scoreWidget(int placement, String name, int score) => Card(
        child: ListTile(
          title: Text("#$placement $name : $score"),
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/business.png'),
          ),
        ),
      );

  Widget leaderboard(Leaderboard leaderboard) => Scaffold(
      appBar: MapTogetherAppBar(
        title: "Leaderboard for " + leaderBoardName,
        actions: [],
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: leaderboard.entries.length,
              itemBuilder: (context, index) => scoreWidget(
                  index + 1,
                  leaderboard.entries[index].user.name,
                  leaderboard.entries[index].score)),
        ),
      ]));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLeaderboard(type, leaderBoardName),
        builder: (BuildContext context, AsyncSnapshot<Leaderboard> snapshot) {
          if (snapshot.hasData)
            return leaderboard(snapshot.data);
          else if (snapshot.hasError)
            return errorData();
          else
            return Expanded(flex: 14, child: waitingLoop());
        });
  }
}
