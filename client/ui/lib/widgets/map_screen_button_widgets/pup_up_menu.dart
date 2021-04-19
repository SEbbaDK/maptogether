import 'package:ui/screens/settings.dart';
import 'package:flutter/material.dart';

import 'map_screen_button.dart';

class PopUpMenu extends StatefulWidget {
  @override
  _PopUpMenuState createState() => _PopUpMenuState();
}

class _PopUpMenuState extends State<PopUpMenu> {
  int index = 0;

  _PopUpMenuState();

  // Use this in the buttons onPressed functions to close the menu again
  void closeMenu() {
    setState(() {
      index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> menuButtons = [
      MapScreenButton(
          child: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Settings())
            );
            closeMenu();
          }),

      MapScreenButton(
          child: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Settings()));
            closeMenu();
          }),

      MapScreenButton(
          child: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Settings()));
            closeMenu();
          }),
    ];

    // This is the menu button itslef
    MapScreenButton menuButton = MapScreenButton(
        width: 75,
        child: Text(
          'Menu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        onPressed: () {
          setState(() {
            index = index ^ 1; // switch from 0 to 1 and from 1 to 0
          });
        });

    // The menu items and the space between them
    List<Widget> temp = [];
    for (int i = 0; i < menuButtons.length; i++) {
      temp.add(menuButtons[i]);
      temp.add(SizedBox(width: 10, height: 10));
    }
    temp.add(
        menuButton); // We still needs to show the menu button to close it again

    // Either the menu-button will be displayed or the Column including the menu items and the menu-button itself
    List<Widget> widgetsToShow = [
      menuButton,
      Column(
        children: temp,
      )
    ];

    return Container(
      child: widgetsToShow[index],
    );
  }
}
