import 'package:client/widgets/map_screen_button_widgets/map_screen_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({
    Key key,
  }) : super(key: key);

  @override
  _InteractiveMapState createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  List<LatLng> taskPoints = [];

  LatLng popUpPositionOnMap = LatLng(0, 0);
  bool showPopUp = false;

  @override
  Widget build(BuildContext context) {
    var markers = taskPoints.map((latlng) {
      return Marker(
        width: 40.0,
        height: 40.0,
        point: latlng,
        builder: (ctx) => Container(
          child: FlutterLogo(),
        ),
      );
    }).toList();

    Widget selector = Container(
      child: FittedBox(
        child: Container(
          decoration: BoxDecoration(
            //color: Colors.grey,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MapScreenButton(
                  child: Text('Tilføj POI'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MapScreenButton(
                  child: Text('Luk'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Marker popUpMarker = Marker(
        height: 250,
        width: 1000,
        point: popUpPositionOnMap,
        builder: (context) => Visibility(
              visible: showPopUp,
              child: FittedBox(
                child: Stack(
                  children: [
                    Container(
                      child: Center(
                        child: Image(
                          image: AssetImage('assets/MapTogether_popUp.png'),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 105,
                      right: -40,
                      child: SizedBox(height: 50, width: 200, child: selector),
                    ),
                  ],
                ),
              ),
            ));

    void _handleLongPress(LatLng latLng) {
      setState(() {
        popUpPositionOnMap = latLng;
        showPopUp = true;
        //taskPoints.add(latLng);
      });
    }

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            onLongPress: (latLng) {
              _handleLongPress(latLng);
            },
            onTap: (latLng) {
              setState(() {
                showPopUp = false;
              });
            },
            center: LatLng(57.04, 9.92),
            // Aalborg
            zoom: 12.0,
            maxZoom: 22.0,
          ),
          layers: [
            TileLayerOptions(
              tileSize: 256,
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              tileProvider: NetworkTileProvider(),
              maxNativeZoom: 18,
            ),

            MarkerLayerOptions(
              markers: markers + [popUpMarker],
            ),

            //MarkerLayerOptions(markers: markers)
          ],
        ),

        /*
        Positioned(
          child: SafeArea(child: selector),
          left: 5,
          bottom: 5,
        ),

         */
      ],
    );
  }
}
