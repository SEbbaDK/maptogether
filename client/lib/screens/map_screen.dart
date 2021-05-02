import 'package:client/location_handler.dart';
import 'package:client/screens/social_screen.dart';
import 'package:client/widgets/map_screen_button_widgets/button_row.dart';
import 'package:client/widgets/map_screen_button_widgets/map.dart';
import 'package:client/widgets/map_screen_button_widgets/map_screen_button.dart';
import 'package:client/widgets/map_screen_button_widgets/pup_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Center(
              child: InteractiveMap(),
            ),
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: SafeArea(
              child: ButtonRow(
                buttons: [
                  MapScreenButton(
                    child: Icon(Icons.person),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SocialScreen()));
                    },
                  ),
                  PopUpMenu(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
