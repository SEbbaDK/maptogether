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

  List<LatLng> tappedPoints = [];

  @override
  Widget build(BuildContext context) {

    var markers = tappedPoints.map((latlng) {
      return Marker(
        width: 40.0,
        height: 40.0,
        point: latlng,
        builder: (ctx) => Container(
          child: FlutterLogo(),
        ),
      );
    }).toList();

    void _handleTap(LatLng latlng) {
      setState(() {
        tappedPoints.add(latlng);
      });
    }

    return FlutterMap(
      options: MapOptions(

        onLongPress: (latLng) {
          print(latLng);
          _handleTap(latLng);
        },
        center: LatLng(57.04, 9.92), // Aalborg
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
          markers: markers,
        ),

        //MarkerLayerOptions(markers: markers)
      ],
    );
  }
}
