
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong/latlong.dart';

import 'package:client/database.dart';
import 'package:client/location_handler.dart';
import 'package:client/login_handler.dart';

import 'package:client/quests/bench_quest/backrest_bench_quest.dart';
import 'package:client/quests/quest_finder.dart';

import 'package:client/screens/social_screen.dart';
import 'package:client/screens/login_screen.dart';

import 'package:client/widgets/map_widgets/map.dart';
import 'package:client/widgets/map_widgets/map_screen_button_widgets/button_row.dart';
import 'package:client/widgets/map_widgets/map_screen_button_widgets/map_screen_button.dart';
import 'package:client/widgets/map_widgets/map_screen_button_widgets/pup_up_menu.dart';


launchSocial(BuildContext context) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SocialScreen()));
    
class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationHandler = context.watch<LocationHandler>();
    final loginHandler = context.watch<LoginHandler>();

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
                      //If no current user, go to login screen
                      if(loginHandler.loggedIntoSocial() != true)
                        requestLogin(context, social: true).then((r) {
							if (r == true)
    							launchSocial(context);
                         });
                      else
                      	launchSocial(context);
                    },
                  ),
                  MapScreenButton(
                    child: Icon(Icons.location_history_rounded),
                    onPressed: () {
                      locationHandler.mapController.move(
                          LatLng(locationHandler.getLocation().latitude,
                              locationHandler.getLocation().longitude),
                          19);
                    },
                  ),
                  StreamBuilder(
                      stream: locationHandler.rotationStream,
                      builder: (BuildContext context, AsyncSnapshot<double> snapshot) =>
                      	Transform.rotate(
                          angle: snapshot.data ?? 0,
                          child: MapScreenButton(
                            child: Icon(Icons.north),
                            onPressed: () {
                              locationHandler.mapController.rotate(0);
                            },
                          ),
                      ),
				  ),
                  MapScreenButton(
                      child: Icon(Icons.wifi_protected_setup),
                      onPressed: () {
                        var questFinder = context.read<QuestHandler>();
                        questFinder.getBenchQuests(
                            locationHandler.mapController.bounds.west,
                            locationHandler.mapController.bounds.south,
                            locationHandler.mapController.bounds.east,
                            locationHandler.mapController.bounds.north);
                      }),
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
