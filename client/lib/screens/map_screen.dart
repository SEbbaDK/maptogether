import 'package:client/database.dart';
import 'package:client/location_handler.dart';
import 'package:client/quests/bench_quest/backrest_bench_quest.dart';
import 'package:client/quests/quest_finder.dart';
import 'package:client/screens/social_screen.dart';
import 'package:client/widgets/map_screen_button_widgets/button_row.dart';
import 'package:client/widgets/map_screen_button_widgets/map.dart';
import 'package:client/widgets/map_screen_button_widgets/map_screen_button.dart';
import 'package:client/widgets/map_screen_button_widgets/pup_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong/latlong.dart';
import 'login_screen.dart';

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
                      //If no current user, go to login screen
                      if(context.read<DummyDatabase>().loginURL == "") {
                        showDialog(
                          context: context,
                          builder: (_) => notLoggedInSocial(context)
                        );
                      }
                      else{
                        Navigator.push(context,MaterialPageRoute(builder: (context) => SocialScreen()));
                      }
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


  AlertDialog notLoggedInSocial(BuildContext context){
    return AlertDialog(
      title: Text('You must be logged in to access social features'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Login to access the social features'),
        ],
      ),
      actions: <Widget>[
        Container(
            color: Colors.lightGreen,
            child: TextButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text(
                'Login',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            )
        ),
        Container(
            color: Colors.lightGreen,
            child: TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(
                'No Thanks',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            )
        ),
      ],
    );
  }
}
