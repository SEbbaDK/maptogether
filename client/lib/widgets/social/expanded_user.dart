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
  SimpleUser otherUser;

  ExpandedUser(
      {@required this.user,
      @required this.currentUser,
      @required this.otherUser});

  @override
  Widget build(BuildContext context) {
    LoginHandler loginHandler =
        Provider.of<LoginHandler>(context, listen: false);
    return Scaffold(
        appBar: MapTogetherAppBar(
          title: "${otherUser.name}'s profile",
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

                    if(otherUser.id == currentUser.id){
                      return Center();
                    }

                    var temp = currentUser.following.firstWhere((element) => element.id == otherUser.id, orElse: () => null);
                    bool friended = false;

                    if(temp != null)
                      friended = true;

                    if(friended) {
                      return Center(
                        child: TextButton(
                          child: Text("Unfollow"),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.red),
                          onPressed: () {
                            loginHandler.mtApi().unfollow(
                                currentUser.id, otherUser.id);
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SocialScreen(1)));
                          },
                        ),
                      );
                    }

                    else if (!friended){
                      return Center(
                        child: TextButton(
                          child: Text("Follow"),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.lightGreen),
                          onPressed: () {
                            loginHandler.mtApi().follow(
                                currentUser.id, otherUser.id);
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SocialScreen(1)));
                          },
                        ),
                      );
                    }

                    return Center();
                }
              ),
              )
            ])));
  }
}