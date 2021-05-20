import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maptogether_api/maptogether_api.dart';
import 'package:provider/provider.dart';

import 'package:client/widgets/app_bar.dart';
import 'package:client/widgets/future_loader.dart';

class LeaderboardWidget extends StatelessWidget {

  Future<Leaderboard> leaderboard;
    
  LeaderboardWidget(
      {Key key, @required this.leaderboard})
      : super(key: key);

  Widget scoreWidget(int placement, String name, int score) => Card(
        child: ListTile(
          title: Text("#$placement $name : $score"),
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/business.png'),
          ),
        ),
      );

  Widget leaderboardWidget(Leaderboard leaderboard) => Scaffold(
      appBar: MapTogetherAppBar(
        title: "Leaderboard for <LEADERBOARDNAME>",
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
  Widget build(BuildContext context) => FutureLoader(
    future: leaderboard,
    builder: (BuildContext context, Leaderboard leaderboard) =>
        leaderboardWidget(leaderboard)
  );
}
