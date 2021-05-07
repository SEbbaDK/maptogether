import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class LocationHandler extends ChangeNotifier {

  // From location lib
  Location _locationService = Location();

  LatLng _currentLocation = LatLng(0, 0); // = LatLng(35, 10);

  MapController mapController;

  LocationHandler() {
    initLocationService();
    mapController = MapController();
  }

  bool _isFirstTime = true;
  void initLocationService() async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 2000,
    );

    _locationService.onLocationChanged.listen((result) {
      _currentLocation = LatLng(result.latitude, result.longitude);

      if (_isFirstTime) {
        mapController.move(_currentLocation, 18);
        _isFirstTime = false;
      }

      notifyListeners();
    });

    LocationData locationData = await _locationService.getLocation();
    _currentLocation = LatLng(locationData.latitude, locationData.longitude);
    notifyListeners();
  }

  LatLng getLocation() {
    updateLocation();
    return _currentLocation;
  }

  Future<void> updateLocation() async {
    LocationData locationData;
    locationData = await _locationService.getLocation();
    _currentLocation = LatLng(locationData.latitude, locationData.longitude);
    notifyListeners();
  }
}
