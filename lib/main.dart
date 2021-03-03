import 'package:flutter/material.dart';
import 'package:dartea/dartea.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

void main()
{
	runApp(Application());
	//runApp(MapTest());
}

class Application extends StatelessWidget
{
	final program = Program
	(
		init,
		update,
		view,
	);

	@override
	Widget build(BuildContext context)
	{
		return MaterialApp
		(
			title: 'Counter Example',
			theme: ThemeData(primarySwatch: Colors.blue),
			home: program.build(key: Key('root_key')),
		);
	}
}

class Model
{
	final int counter;
	Model(this.counter);
}

abstract class Message {}
class Increment implements Message {}

Upd<Model, Message> init() => Upd(Model(0));

Upd<Model, Message> update(Message msg, Model model)
{
	if (msg is Increment)
	{
		return Upd(Model(model.counter + 1));
	}
	return Upd(model);
}

Widget view(BuildContext context, Dispatch<Message> dispatch, Model model)
{
	return Scaffold
	(
		appBar: AppBar
		(
			title: Text('Elm Architecture'),
			actions: <Widget>
			[
				RaisedButton
				(
					child: Text('${model.counter}'),
					onPressed: () => dispatch(Increment()),
				),
			],
		),
		body: FlutterMap
		(
			options: new MapOptions
			(
				center: new LatLng(51.5, -0.09),
				zoom: 13.0,
			),
			layers:
			[
				TileLayerOptions
				(
					urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
					subdomains: ['a', 'b', 'c']
				),
				MarkerLayerOptions
				(
					markers:
					[
						Marker
						(
							width: 80.0,
							height: 80.0,
							point: LatLng(51.5, -0.09),
							builder: (ctx) =>
							Container
							(
								child: FlutterLogo(),
							),
						),
					],
				),
			],
		),
	);
}
