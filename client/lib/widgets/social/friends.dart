import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maptogether_api/maptogether_api.dart' as mt;

import 'package:client/widgets/social/leaderboard.dart';
import 'package:client/widgets/social/add_friend.dart';
import 'package:client/widgets/future_loader.dart';

//TODO: move friends list to a seperate file or server
class Friends extends StatelessWidget {
  Future<mt.User> user;
  Friends(this.user);

  static const Widget seperator = const Divider(thickness: 2, height: 2);

  Widget friendItem(BuildContext context, mt.SimpleUser user) => ListTile(
        onLongPress: () {
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 100,
                  color: Colors.orange,
                  child: Center(
                    child: TextButton(
                      child: Text("Unfollow"),
                      style: TextButton.styleFrom(
                          primary: Colors.white, backgroundColor: Colors.red),
                      onPressed: () {
                        print("UNFOLLOW SOMEONE");
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              });
        },
        title: Text(user.name),
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/business.png'),
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
      child: FutureLoader<mt.User>(
          future: user,
          builder: (BuildContext context, mt.User user) => Column(
                children: <Widget>[
                  Expanded(
                      flex: 14,
                      child: ListView.separated(
                        separatorBuilder: (_, __) => seperator,
                        itemCount: user.following.length,
                        itemBuilder: (context, index) =>
                            friendItem(context, user.following[index]),
                      )),
                  Expanded(
                    flex: 2,
                    child: TextButton(
                      child: Text(
                        'Follow New',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddFriend()));
                      },
                    ),
                  ),
                ],
              )));
}
