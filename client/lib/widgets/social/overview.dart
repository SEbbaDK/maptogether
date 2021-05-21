import 'package:flutter/material.dart';
import 'package:maptogether_api/maptogether_api.dart';
import 'leaderboard.dart';
import 'package:provider/provider.dart';

import 'package:client/login_handler.dart';
import 'package:client/widgets/social/user_overview.dart';
import 'package:client/widgets/future_loader.dart';

class Overview extends StatelessWidget {
  Future<User> user;
  Overview(this.user);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex: 2, child: UserOverview(user)),
          Expanded(flex: 7, child:
              DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: TabBar(
                  indicatorColor: Colors.green,
                  labelColor: Colors.lightGreen,
                  unselectedLabelColor: Colors.black,
                  isScrollable: false,
                  tabs: <Widget>[
                    Tab(text: "All Time"),
                    Tab(text: "Monthly"),
                    Tab(text: "Weekly"),
                  ]),
              body: TabBarView(
                children: [
                  leaderBoardWidget(LeaderboardType.all_time),
                  leaderBoardWidget(LeaderboardType.monthly),
                  leaderBoardWidget(LeaderboardType.weekly),
                ],
              ),
            ),
          ),
          ),
        ],
      );

  //TODO: make future builder dependent
  Widget leaderBoardWidget(LeaderboardType type) => FutureLoader(
        future:
            user, // TODO: actually use the users leaderboards instead of just the constant
        builder: (BuildContext context, User user) =>
            ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) =>
                    leaderboardItem(context, type, "global")),
      );

  Widget leaderboardItem(BuildContext context, LeaderboardType type, String name) => Card(
          child: ListTile(
        leading: Text(name),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LeaderboardWidget(leaderboard: context
                    .watch<LoginHandler>()
                    .mtApi()
                    .leaderboard(type, name)),
              ));
        },
      ));
}
