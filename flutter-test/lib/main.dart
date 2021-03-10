import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dartea/dartea.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


final Random random = Random();

void main() {
  runApp(Application());
  //runApp(MapTest());
}

class Application extends StatelessWidget {
  final program = Program(
    init,
    update,
    view,
	subscription:
		_periodicTimerSubscription,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: program.build(key: Key('root_key')),
    );
  }
}

class Model {
  final int counter;
  final Position position;
  final List<LatLng> markers;
  Model(this.counter, this.position, this.markers);
}

abstract class Message {}

class Increment implements Message {}

class AddMarker implements Message {
  final LatLng coord;
  AddMarker(this.coord);
}

class PositionUpdate implements Message {
	final Position position;
	PositionUpdate(this.position);
}

Upd<Model, Message> init() => Upd(Model(
	0,
	Position(latitude: 56, longitude: 9, accuracy: 1, heading: 0, altitude: 0, speed: 0),
	[]
));

Upd<Model, Message> update(Message msg, Model model) {
  if (msg is Increment) {
    return Upd(Model(model.counter + 1, model.position, model.markers));
  }
  if (msg is AddMarker) {
    return Upd(Model(model.counter, model.position, model.markers + [msg.coord]));
  }
  if (msg is PositionUpdate) {
	return Upd(Model(model.counter, msg.position, model.markers));
  }
  return Upd(model);
}

Widget view(BuildContext context, Dispatch<Message> dispatch, Model model) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Elm Architecture'),
      actions: <Widget>[
        RaisedButton(
          child: Text('${model.counter}'),
          onPressed: () {
			final lat = (random.nextDouble() * 180.0) - 90.0;
            final long = (random.nextDouble() * 360.0) - 180.0;
            return dispatch(AddMarker(LatLng(lat, long)));
          },
        ),
      ],
    ),
    body: FlutterMap(
      options: new MapOptions(
        center: new LatLng(0, 0),
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: viewMarkers(model.position, model.markers, dispatch),
        ),
      ],
    ),
  );
}

List<Marker> viewMarkers(Position position, List<LatLng> markers, Dispatch<Message> dispatch) {
  List<Marker> list = [];
  for (var coord in markers)
    list.add(Marker(
      width: 25.0,
      height: 25.0,
      point: coord,
      builder: (ctx) => Container(
        child: Image.network("https://i.stack.imgur.com/TW0RT.png"),
		),
    ));

	if (position != null)
		list.add(Marker(
		  width: 25.0,
		  height: 25.0,
		  point: LatLng(position.latitude, position.longitude),
		  builder: (ctx) => Container(
			child: Image.network("https://i.stack.imgur.com/TW0RT.png"),
			),
		));
  return list;
}

Timer _periodicTimerSubscription(Timer currentTimer, Dispatch<Message> dispatch, Model model) {
	if (currentTimer == null)
		return Timer.periodic(Duration(seconds: 5), (_) async => 
			await getPosition().then((pos) => dispatch(PositionUpdate(pos)))
		);
	else
		return currentTimer;
}

Future<Position> getPosition() async {
	bool locationEnabled = await Geolocator.isLocationServiceEnabled();
	if (!locationEnabled)
		return Future.error("No location enabled");
	LocationPermission permission = await Geolocator.checkPermission();
	if (permission == LocationPermission.denied)
	{
		await Permission.locationWhenInUse.request();
		return await getPosition();
	}
	return await Geolocator.getCurrentPosition(); //(desiredAccuracy: LocationAccuracy.best);
}
