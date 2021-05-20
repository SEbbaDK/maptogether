import 'package:client/location_handler.dart';
import 'package:client/quests/quest.dart';
import 'package:client/quests/quest_handler.dart';
import 'package:client/widgets/map_widgets/map_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:time_range_picker/time_range_picker.dart';

class PointOfInterest {
  // TODO: I think this should be moved to some model package
  String name;
  LatLng location;
  TimeOfDay openingTime;
  TimeOfDay closingTime;

  PointOfInterest(String _name, LatLng _location, TimeRange timeRange) {
    name = _name;
    location = _location;
    //openingTime = timeRange.startTime;
    //closingTime = timeRange.endTime;
  }
}

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({
    Key key,
  }) : super(key: key);

  @override
  _InteractiveMapState createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  List<PointOfInterest> taskPoints = [];

  TimeRange result;
  String name = "";
  LatLng popUpPositionOnMap = LatLng(0, 0);
  bool showPopUp = false;
  TextEditingController poiNameController = TextEditingController();

  MapController _mapController;

  @override
  Widget build(BuildContext context) {
    _mapController = context.watch<LocationHandler>().mapController;

    Marker currentPositionMarker = Marker(
      point: context.watch<LocationHandler>().getLocation(),
      builder: (context) => Icon(
        Icons.location_history_rounded,
        color: Colors.red,
      ),
    );

    var taskMarkers = taskPoints.map((poi) {
      return Marker(
        width: 100.0,
        height: 100.0,
        point: poi.location,
        builder: (ctx) => FittedBox(
          child: TextButton(
            child: Icon(
              Icons.edit_location_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              print('This is ' + poi.name);
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
                        showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                  height: 300,
                                  color: Colors.green,
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text('Add Point of Interest'),
                                      TextField(
                                        controller: poiNameController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Name of PoI',
                                        ),
                                      ),
                                      DropDown(),
                                      TextButton(
                                          child: Text('Choose time'),
                                          onPressed: () async {
                                            result = await showTimeRangePicker(
                                              context: context,
                                            );
                                          }),
                                      ElevatedButton(
                                          child:
                                              const Text('Close BottomSheet'),
                                          onPressed: () {
                                            taskPoints.add(PointOfInterest(
                                                poiNameController.text,
                                                popUpPositionOnMap,
                                                result)); // TODO: Det er nok meningen at der skal åbnes en ny POI screen eller lignende
                                            setState(() {
                                              showPopUp = false;
                                              poiNameController.text = "";
                                              Navigator.pop(context);
                                            });
                                          })
                                    ],
                                  )));
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

    // Finding quests and creating MapMarkers for each of them
    List<Quest> quests = context.watch<QuestHandler>().quests;
    List<MapMarker> questMarkers = [];
    quests.forEach((quest) {
      questMarkers.add(MapMarker(context, quest));

      /*
       Marker(
            width: 100.0,
            height: 100.0,
            point: LatLng(57.048820, 9.921747),
            builder: (ctx) => FittedBox(
              child: TextButton(
                child: Icon(
                  Icons.edit_location_rounded,
                  color: Colors.pink,
                ),
                onPressed: () {
                  print('This is ');
                },
              ),
            ),
          ));
       */

    });



    return FlutterMap(
      mapController: _mapController,
      children: [
        TileLayerWidget(
          options: TileLayerOptions(
            tileSize: 256,
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
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
        center: context.watch<LocationHandler>().getLocation(),
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
          markers: questMarkers,
          polygonOptions: PolygonOptions(
              borderColor: Colors.blueAccent,
              color: Colors.black12,
              borderStrokeWidth: 3),
          builder: (context, markers) {
            return Row(
              children: [
                Icon(Icons.not_listed_location_rounded),
                Text(markers.length.toString()),
              ],
            );
          },
        ),
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
          markers: [popUpMarker] + [currentPositionMarker],
        ),
      ],
    );
  }
}

class DropDown extends StatefulWidget {
  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        hint: Text('Choose'),
        value: selectedValue,
        onChanged: (String changedValue) {
          setState(() {
            selectedValue = changedValue;
            print(selectedValue);
          });
        },
        items:
            <String>['Shop', 'Bar', 'Restaurent', 'Other'].map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList());
  }
}

/* TODO: Slet !!
List<Marker> backrestQuestMarkers = quests.map((quest) {
  List<Widget> textButtons = [];
  for (int i = 0; i < quest.getPossibilities().length; i++) {
    textButtons.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        child: Text(quest.getPossibilities()[i]),
        onPressed: () async {
          LoginHandler loginHandler = context.read<LoginHandler>();
          QuestHandler questHandler = context.read<QuestHandler>();
          LocationHandler locationHandler = context.read<LocationHandler>();

          if (!loginHandler.loggedIntoOSM())
            requestLogin(context, social: false);
          else
            questHandler
                .answerBenchQuest(loginHandler, locationHandler, questHandler, quest, i)
                .then((value) => Navigator.pop(context));
        },
      ),
    ));
  }

  return Marker(
      width: 60,
      height: 60,
      point: quest.position,
      builder: (context) => FittedBox(
        child: TextButton(
          child: Icon(
            Icons.airline_seat_recline_normal_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    height: 200,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            quest.getQuestion(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ] +
                          textButtons,
                    ),
                  );
                });
          },
        ),
      ));
}).toList();
*/
