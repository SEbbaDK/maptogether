import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:client/widgets/app_bar.dart';
import 'package:client/widgets/social/friends.dart';
import 'package:client/widgets/social/groups.dart';
import 'package:client/widgets/social/history.dart';
import 'package:client/widgets/social/overview.dart';
import 'package:client/widgets/social/user_overview.dart';
import 'package:client/login_flow.dart';
import 'package:client/login_handler.dart';
import 'package:maptogether_api/maptogether_api.dart';

class SocialScreen extends StatefulWidget {
  @override
  int initIndex;
  _SocialScreenState createState() => _SocialScreenState(initIndex);

  SocialScreen(this.initIndex);
}

class _SocialScreenState extends State<SocialScreen> {
  int menuIndex = 0;

  Future<User> user = null;
  List<Widget> menuItems = null;

  _SocialScreenState(this.menuIndex);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      user = context.read<LoginHandler>().user();
      menuItems = [
        Overview(user),
        Friends(user),
        Groups(),
        History(),
      ];
    }

    return Scaffold(
      appBar: MapTogetherAppBar(
        title: 'Social',
        actions: [
          TextButton(
              child: Text("Log out", style: TextStyle(color: Colors.white)),
              onPressed: () {
                context.read<LoginHandler>().logout();
                Navigator.pop(context);
              }),
        ],
      ),
      body: Container(
        //color: Colors.grey,
        child: Center(
          child: menuItems[menuIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Overview',
            backgroundColor: Colors.lightGreen,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Friends',
            backgroundColor: Colors.lightGreen,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_sharp),
            label: 'Groups',
            backgroundColor: Colors.lightGreen,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
            backgroundColor: Colors.lightGreen,
          ),
        ],
        currentIndex: menuIndex,
        selectedItemColor: Colors.black,
        onTap: (int index) {
          setState(() {
            menuIndex = index;
          });
        },
      ),
    );
  }
}
