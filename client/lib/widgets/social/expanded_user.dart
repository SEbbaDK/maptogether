import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maptogether_api/maptogether_api.dart';
import '../app_bar.dart';
import 'package:client/login_handler.dart';
import 'overview.dart';
import 'package:client/screens/social_screen.dart';

class ExpandedUser extends StatelessWidget {
  Future<User> user;
  User currentUser;
  SimpleUser friend;

  ExpandedUser(
      {@required this.user,
      @required this.currentUser,
      @required this.friend});

  @override
  Widget build(BuildContext context) {
    LoginHandler loginHandler =
        Provider.of<LoginHandler>(context, listen: false);
    return Scaffold(
        appBar: MapTogetherAppBar(
          title: "${friend.name}'s profile",
          actions: [],
        ),
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              Expanded(flex: 7, child: Overview(user)),
              Expanded(
                flex: 2,
                child: Builder(
                  builder: (BuildContext context){
                    if(true) {
                      return Center(
                        child: TextButton(
                          child: Text("Unfollow"),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.red),
                          onPressed: () {
                            loginHandler.mtApi().unfollow(
                                currentUser.id, friend.id);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SocialScreen(1)));
                          },
                        ),
                      );
                    }
                    else{
                      return Center(
                        child: TextButton(
                          child: Text("Unfollow"),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.red),
                          onPressed: () {
                            loginHandler.mtApi().unfollow(
                                currentUser.id, friend.id);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SocialScreen(1)));
                          },
                        ),
                      );
                    }
                }
              ),
              )
            ])));
  }
}