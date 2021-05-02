import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class LocationHandler extends ChangeNotifier {
  // From location lib
  Location _locationService = Location();

  LatLng _currentLocation = LatLng(0, 0); // = LatLng(35, 10);

  LocationHandler() {
    initLocationService();
  }

  void initLocationService() async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 2000,
    );


    LocationData locationData = await _locationService.getLocation();
    _currentLocation = LatLng(locationData.latitude, locationData.longitude);
  }

  LatLng getLocation() {
    updateLocation().then((value) {
      return _currentLocation;
    });
    notifyListeners();
    return _currentLocation;
  }

  Future<void> updateLocation() async {
    LocationData locationData;
    locationData = await _locationService.getLocation();
    _currentLocation = LatLng(locationData.latitude, locationData.longitude);
  }
}
