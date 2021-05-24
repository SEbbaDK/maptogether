import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maptogether_api/maptogether_api.dart';
import '../app_bar.dart';
import 'user_overview.dart';
import 'package:client/login_handler.dart';
import 'overview.dart';

import 'package:client/widgets/future_loader.dart';

class ExpandedFriend extends StatelessWidget {
  Future<User> user;
  int currentUserId, friendId;
  String friendName;

  ExpandedFriend(
      {@required this.user, @required this.currentUserId, @required this.friendId, @required this.friendName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MapTogetherAppBar(
          title: 'Follow New',
          actions: [],
        ),
        body: Container(
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(flex: 7, child: Overview(user)),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: TextButton(
                        child: Text("Unfollow"),
                        style: TextButton.styleFrom(
                            primary: Colors.white, backgroundColor: Colors.red),
                        onPressed: () {

                        },
                      ),
                    ),
                  ),
                ]
            )
        )
    );
  }
}