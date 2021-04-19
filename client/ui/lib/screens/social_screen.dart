import 'package:ui/widgets/app_bar.dart';
import 'package:ui/widgets/social_menu_widgets/friends.dart';
import 'package:ui/widgets/social_menu_widgets/groups.dart';
import 'package:ui/widgets/social_menu_widgets/history.dart';
import 'package:ui/widgets/social_menu_widgets/overview.dart';
import 'package:ui/widgets/social_menu_widgets/user_overview.dart';
import 'package:flutter/material.dart';

class SocialScreen extends StatefulWidget {
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  int menuIndex = 0;

  List<Widget> menuItems = [
    Overview(),
    Friends(),
    Groups(),
    History(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MapTogetherAppBar(
        title: 'Social menu',
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
