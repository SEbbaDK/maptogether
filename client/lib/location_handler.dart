import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class LocationHandler extends ChangeNotifier {
  // From location lib
  Location _locationService = new Location();

  LatLng _currentLocation = LatLng(0, 0); // = LatLng(35, 10);

  LatLng get currentLocation => _currentLocation;

  LocationHandler() {
    initLocationService();
  }

  initLocationService() async {
    /* await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    */

    LocationData locationData = await _locationService.getLocation();
    _currentLocation = LatLng(locationData.latitude, locationData.longitude);
  }

  LatLng getLocation() {
    updateLocation().then((value) {
      return _currentLocation;
    });
    return _currentLocation;
  }

  Future<void> updateLocation() async {
    LocationData locationData;
    locationData = await _locationService.getLocation();
    _currentLocation = LatLng(locationData.latitude, locationData.longitude);
  }
}
