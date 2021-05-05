import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class Event{
  String type;
  String time;
  Icon icon;

  Event(String _type, DateTime _time, Icon i){
    type = _type;
    time = DateFormat('yyyy-MM-dd  kk:mm:ss').format(_time).toString();
    icon = i;
  }
}
class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  List<Event> events = [
    Event("Marker Add", DateTime.now(), Icon(Icons.add_location_alt)),
    Event("Marker Delete", DateTime.now(), Icon(Icons.remove)),
    Event("Created group P8", DateTime.now(), Icon(Icons.group)),
    Event("Added Simon to P8", DateTime.now(), Icon(Icons.person_add)),
    Event("Added Phillip to P8", DateTime.now(), Icon(Icons.person_add)),
    Event("Marker Add", DateTime.now(), Icon(Icons.add_location_alt)),
    Event("Marker Add", DateTime.now(), Icon(Icons.add_location_alt)),
    Event("Marker Add", DateTime.now(), Icon(Icons.add_location_alt)),
    Event("Marker Delete", DateTime.now(), Icon(Icons.remove)),
    Event("Marker Add", DateTime.now(), Icon(Icons.add_location_alt)),
    Event("Marker Delete", DateTime.now(), Icon(Icons.remove)),
    Event("Created group P8", DateTime.now(), Icon(Icons.group)),
    Event("Added Simon to P8", DateTime.now(), Icon(Icons.person_add)),
    Event("Added Phillip to P8", DateTime.now(), Icon(Icons.person_add)),
    Event("Marker Add", DateTime.now(), Icon(Icons.add_location_alt)),
    Event("Marker Add", DateTime.now(), Icon(Icons.add_location_alt)),
    Event("Marker Add", DateTime.now(), Icon(Icons.add_location_alt)),
    Event("Marker Delete", DateTime.now(), Icon(Icons.remove)),
    Event("Marker Add", DateTime.now(), Icon(Icons.add_location_alt)),
    Event("Marker Delete", DateTime.now(), Icon(Icons.remove)),
    Event("Created group P8", DateTime.now(), Icon(Icons.group)),
    Event("Added Simon to P8", DateTime.now(), Icon(Icons.person_add)),
    Event("Added Phillip to P8", DateTime.now(), Icon(Icons.person_add)),
    Event("Marker Add", DateTime.now(), Icon(Icons.add_location_alt)),
    Event("Marker Add", DateTime.now(), Icon(Icons.add_location_alt)),
    Event("Marker Add", DateTime.now(), Icon(Icons.add_location_alt)),
    Event("Marker Delete", DateTime.now(), Icon(Icons.remove))
  ];


  Widget _buildSuggestions(){

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(40.0),
      child: Column(

        children: <Widget>[
          Expanded(
              flex: 1,
              child: Text("History")),
          Expanded(
              flex: 7,
              child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: events[index].icon,
                      title: Text(events[index].type + " - " + events[index].time)
                    );
                  }
              )
          ),
        ],
      ),
    );
  }
}