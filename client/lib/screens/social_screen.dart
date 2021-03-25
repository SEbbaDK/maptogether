import 'package:client/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class SocialScreen extends StatefulWidget {
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  int menuIndex = 0;

  List<Widget> menuItems = [
    Text('1'),
    Text('2'),
    Text('3'),
    Text('4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MapTogetherAppBar(
        title: 'Social menu',
      ),
      body: Container(
        child: Center(
          child: menuItems[menuIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboards',
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
