import 'dart:async';
import 'package:location/location.dart';
import 'user_location.dart';

class LocationService {
  Location location = Location();
  late StreamController<UserLocation> _locationStreamController;
  late Stream<UserLocation> _locationStream;
  late StreamSubscription<UserLocation> _locationSubscription;

  LocationService() {
    _locationStreamController = StreamController<UserLocation>();
    _locationStream = _locationStreamController.stream;

    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        _locationSubscription = location.onLocationChanged.map((locationData) =>
            UserLocation(
              latitude: locationData.latitude ?? 0.0,
              longitude: locationData.longitude ?? 0.0,
            )).listen((userLocation) {
          _locationStreamController.add(userLocation);
        });
      }
    });
  }

  Stream<UserLocation> get locationStream => _locationStream;

  void dispose() {
    _locationSubscription.cancel();
    _locationStreamController.close();
  }

  void stopLocationService() {
    _locationSubscription.cancel();
  }
}
