import 'package:client/screens/social_screen.dart';
import 'package:client/widgets/map_screen_button_widgets/button_row.dart';
import 'package:client/widgets/map_screen_button_widgets/map_screen_button.dart';
import 'package:client/widgets/map_screen_button_widgets/pup_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Center(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(57.04, 9.92), // Aalborg
                  zoom: 12.0,
                  maxZoom: 22.0,
                ),
                layers: [
                  TileLayerOptions(
                    tileSize: 256,
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    tileProvider: NetworkTileProvider(),
                    maxNativeZoom: 18,
                  ),
                  //MarkerLayerOptions(markers: markers)
                ],
              ),
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
