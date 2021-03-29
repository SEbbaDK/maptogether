import 'package:client/screens/social_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'settings.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: MapTogetherAppBar(
        title: 'MapTogether',
        actionButtons: [
          IconButton(
            icon: Icon(Icons.person_rounded),
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SocialScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
        ],
      ),

       */
      body: Stack(
        children: [
          Container(
            child: Center(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(57.04, 9.92),
                  zoom: 12.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    tileProvider: NetworkTileProvider(),
                  ),
                  //MarkerLayerOptions(markers: markers)
                ],
              ),
            ),
          ),


          // Positioned button container dims ...
          Row(
            children: [

            ],
          ),

          Positioned(
            right: 5,
            bottom: 5,
            child: SafeArea(
              // avoids rounded screen problem
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  //shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SocialScreen()));
                  },
                  focusColor: Colors.lightGreen,
                ),
              ),
            ),
          ),
          Positioned(
            right: 60,
            bottom: 5,
            child: SafeArea(
              // avoids rounded screen problem
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  //shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                  focusColor: Colors.lightGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Menu'),
        onPressed: () async {
          var navigationResult = await Navigator.push(
              context, new MaterialPageRoute(builder: (context) => Page2()));
          if (navigationResult == true) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text('Navigation result success'),
                    ));
          }
        },
      ),
 */
