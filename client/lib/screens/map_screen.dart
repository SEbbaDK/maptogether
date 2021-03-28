import 'package:client/screens/page2.dart';
import 'package:client/screens/social_screen.dart';
import 'package:client/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'settings.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MapTogetherAppBar(
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
      floatingActionButton: FloatingActionButton(
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
      body: Container(
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
    );
  }
}
