import 'dart:async';

import 'package:location/location.dart';
import 'user_location.dart';

class LocationService{
  Location location = Location();
  StreamController<UserLocation> _locationStreamController = StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationStreamController.stream;

  LocationService(){
    location.requestPermission().then((permissionStatus){
      if(permissionStatus == PermissionStatus.granted){
        location.onLocationChanged.listen((locationData) {
          if(locationData != null){
            _locationStreamController.add(UserLocation(
              latitude: locationData.latitude ?? 0.0, // Gantilah 0.0 dengan nilai default yang sesuai
              longitude: locationData.longitude ?? 0.0, // Gantilah 0.0 dengan nilai default yang sesuai
            ));
          }
        });
      }
    });
  }
  void dispose() => _locationStreamController.close();
}