import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('samples.flutter.dev/battery');

  String _batteryLevel = '';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _pub() async {
    await platform.invokeMethod('publish');
    setState(() {
      _batteryLevel = "publishing";
    });
  }

  Future<void> _getExceptionMessage() async {
    String exceptionMessage = await platform.invokeMethod("getExceptionMessage");
    setState(() {
      _batteryLevel = exceptionMessage;
    });
  }

  Future<void> _sub() async {
    String message;

    try {
      message = await platform.invokeMethod('subscribe');
    } on PlatformException catch (e) {
      message = "Failed: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = message;
    });
  }

  Future<void> _hej() async {
    await platform.invokeMethod('returnHej');
    setState(() {
      _batteryLevel = 'test';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('Get Battery Level'),
              onPressed: _getBatteryLevel,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text('Publish'),
                  onPressed: _pub,
                ),
                ElevatedButton(
                    onPressed: _getExceptionMessage,
                    child: Text('Exception M')
                ),
                ElevatedButton(
                  child: Text('UnPublish'),
                  onPressed: _pub,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text('Subscribe'),
                  onPressed: _sub,
                ),
                ElevatedButton(
                  child: Text('UnSubscribe'),
                  onPressed: _sub,
                ),
              ],
            ),
            Text(_batteryLevel),
          ],
        ),
      ),
    );
  }
}
