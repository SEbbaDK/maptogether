import 'package:client/location_handler.dart';
import 'package:client/screens/social_screen.dart';
import 'package:client/widgets/map_screen_button_widgets/button_row.dart';
import 'package:client/widgets/map_screen_button_widgets/map.dart';
import 'package:client/widgets/map_screen_button_widgets/map_screen_button.dart';
import 'package:client/widgets/map_screen_button_widgets/pup_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong/latlong.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    LocationHandler locationHandler = context.watch<LocationHandler>();

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
                  MapScreenButton(
                      child: Icon(Icons.location_history_rounded),
                      onPressed: () {
                        locationHandler.mapController.move(
                            LatLng(locationHandler.getLocation().latitude, locationHandler.getLocation().longitude),
                            19);
                      },
                  ),
                  MapScreenButton(
                    child: Icon(Icons.north),
                    onPressed: () {
                      locationHandler.mapController.rotate(0);
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
