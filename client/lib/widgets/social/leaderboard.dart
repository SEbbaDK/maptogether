import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maptogether_api/maptogether_api.dart';
import 'package:provider/provider.dart';
import 'expandedUser.dart';
import 'package:client/login_handler.dart';

import 'package:client/widgets/app_bar.dart';
import 'package:client/widgets/future_loader.dart';

class LeaderboardWidget extends StatelessWidget {
  Future<Leaderboard> leaderboard;
  String name;
  int currentUserId;

  LeaderboardWidget(
      {Key key,
      @required this.leaderboard,
      @required this.name,
      @required this.currentUserId})
      : super(key: key);

  Widget scoreWidget(context, int placement, String name, int score,
          SimpleUser otherUser) =>
      ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ExpandedUser(
                  user: context.read<LoginHandler>().mtApi().user(otherUser.id),
                  friend: otherUser,
                  currentUserId: currentUserId)));
        },
        title: Text("#$placement $name : $score"),
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/business.png'),
        ),
      );

  Widget leaderboardWidget(Leaderboard leaderboard) => Scaffold(
      appBar: MapTogetherAppBar(
        title: name,
        actions: [],
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(thickness: 0.5),
              itemCount: leaderboard.entries.length,
              itemBuilder: (context, index) => scoreWidget(
                    context,
                    index + 1,
                    leaderboard.entries[index].user.name,
                    leaderboard.entries[index].score,
                    SimpleUser(
                        id: leaderboard.entries[index].user.id,
                        name: leaderboard.entries[index].user.name),
                  )),
        ),
      ]));

  @override
  Widget build(BuildContext context) => FutureLoader(
      future: leaderboard,
      builder: (BuildContext context, Leaderboard leaderboard) =>
          leaderboardWidget(leaderboard));
}
