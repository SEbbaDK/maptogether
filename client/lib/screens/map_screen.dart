import 'package:client/screens/social_screen.dart';
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
          Positioned(
            bottom: 5,
            child: SafeArea(
              child: ButtonRow(
                buttons: [
                  MapScreenButton(
                    icon: Icons.person,
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SocialScreen()));
                    },
                  ),
                  MapScreenButton(icon: Icons.settings,),
                  MapScreenButton(icon: Icons.compass_calibration),
                  MapScreenButton(icon: Icons.update),
                  MapScreenButton(icon: Icons.chat_outlined),
                  MapScreenButton(icon: Icons.leaderboard),
                  MapScreenButton(icon: Icons.widgets),
                  MapScreenButton(icon: Icons.face),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({Key key, this.buttons}) : super(key: key);

  final List<MapScreenButton> buttons;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    widgets.add(SizedBox(width: 5));
    for (int i = 0; i < buttons.length; i++) {
      widgets.add(buttons[i]);
      widgets.add(SizedBox(width: 5));
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: widgets,
      ),
    );
  }
}

class MapScreenButton extends StatelessWidget {
  const MapScreenButton(
      {Key key, @required this.icon, @required this.onPressed})
      : super(key: key);

  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        //shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.black,
        ),
        onPressed: onPressed,

        /* ()  {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => goToScreen));
          }

               */
      ),
    );
  }
}