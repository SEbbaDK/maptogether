import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
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
    var taskMarkers = taskPoints.map((latlng) {
      return Marker(
        width: 100.0,
        height: 100.0,
        point: latlng,
        builder: (ctx) => FittedBox(
          child: TextButton(
            child: Icon(
              Icons.edit_location_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              print('This is a quest!');
            },
          ),
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
                padding: const EdgeInsets.all(2.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.lightGreen,
                    ),
                    child: TextButton(
                      onPressed: () {
                        taskPoints.add(
                            popUpPositionOnMap); // TODO: Det er nok meningen at der skal åbnes en ny POI screen eller lignende
                        setState(() {
                          showPopUp = false;
                        });
                      },
                      child: Text(
                        'Add Point of Interest',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
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
      });
    }

    return Stack(
      children: [
        FlutterMap(
          children: [
            TileLayerWidget(
              options: TileLayerOptions(
                tileSize: 256,
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                tileProvider: NetworkTileProvider(),
                maxNativeZoom: 18,
              ),
            ),
          ],
          options: MapOptions(
            plugins: [
              MarkerClusterPlugin(),
            ],
            onLongPress: (latLng) {
              _handleLongPress(latLng);
            },
            onTap: (latLng) {
              setState(() {
                showPopUp = false;
              });
            },
            // Aalborg
            center: LatLng(57.04, 9.92),
            zoom: 12.0,
            maxZoom: 22.0,
          ),
          layers: [
            MarkerClusterLayerOptions(
              maxClusterRadius: 100,
              size: Size(40, 40),
              fitBoundsOptions: FitBoundsOptions(
                padding: EdgeInsets.all(50),
              ),
              markers: taskMarkers,
              polygonOptions: PolygonOptions(
                  borderColor: Colors.blueAccent,
                  color: Colors.black12,
                  borderStrokeWidth: 3),
              builder: (context, markers) {
                return FloatingActionButton(
                  child: Text(markers.length.toString()),
                  onPressed: null,
                );
              },
            ),
            //MarkerLayerOptions(markers: markers)
            MarkerLayerOptions(
                markers: [popUpMarker],
              ),
          ],
        ),
      ],
    );
  }
}
