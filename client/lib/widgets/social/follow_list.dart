import 'package:client/login_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maptogether_api/maptogether_api.dart' as mt;

import 'package:client/widgets/social/follow_new.dart';
import 'package:client/widgets/future_loader.dart';
import 'package:client/screens/social_screen.dart';
import 'package:client/widgets/social/expanded_user.dart';

//TODO: move friends list to a seperate file or server
class FollowList extends StatelessWidget {
  Future<mt.User> user;
  FollowList(this.user);

  static const Widget seperator = const Divider(thickness: 2, height: 2);

  Widget friendItem(BuildContext context, mt.SimpleUser otherUser) =>
      FutureLoader<mt.User>(
          future: user,
          builder: (BuildContext context, mt.User user) => ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ExpandedUser(
                          user: context
                              .read<LoginHandler>()
                              .mtApi()
                              .user(otherUser.id),
                          currentUser: user,
                          friend: otherUser)));
                },
                onLongPress: () {
                  LoginHandler loginHandler =
                      Provider.of<LoginHandler>(context, listen: false);
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
                                  primary: Colors.white,
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                loginHandler
                                    .mtApi()
                                    .unfollow(user.id, otherUser.id);
                                print("NAME IS: " + otherUser.name);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SocialScreen(1)));
                              },
                            ),
                          ),
                        );
                      });
                },
                title: Text(otherUser.name),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/business.png'),
                ),
              ));

  @override
  Widget build(BuildContext context) => Container(
      child: FutureLoader<mt.User>(
          future: user,
          builder: (BuildContext context, mt.User user) => Column(
                children: <Widget>[
                  Expanded(
                      flex: 13,
                      child: ListView.separated(
                        separatorBuilder: (_, __) => seperator,
                        itemCount: user.following.length,
                        itemBuilder: (context, index) =>
                            friendItem(context, user.following[index]),
                      )),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      color: Colors.lightGreen,
                      child: TextButton(
                        child: Text(
                          'Follow New',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FollowNew(user.id)));
                        },
                      ),
                    ),
                  ),
                ],
              )));
}
