import 'dart:math';

import 'package:donde/Store.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class LocationServices{


  static Future<Position> getUsersLocation()async{
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Store.position = await Geolocator.getCurrentPosition();
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return Store.position!;
  }


  static Future<List<Location>> getLocationsFromString(String str)async{
    print("here22");
    return await locationFromAddress(str).onError((error, stackTrace) => []);
  }

  static String getDistance(Location location){
    if(Store.position != null) {
      return distanceToString(Geolocator.distanceBetween(
        location.latitude, location.longitude, Store.position!.latitude,
        Store.position!.longitude,).toInt());
    }
    return "not found";
  }
  static String distanceToString(int dist){
    if(dist < 1000){
      return "${dist} m";
    }else{
      return "${(dist/1000).toInt()}km away";
    }
  }




  static double getDirection(Location location){
    double lat = -location.latitude+Store.position!.latitude;
    double long = location.longitude-Store.position!.longitude;

    print("radians${atan2(lat, long)}");
    return atan2(lat, long);
  }


  static Future<Placemark?> getAdressOfCurrentLocation(Location loc)async{
    Position position = await getUsersLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark? placemark = placemarks.first;
    loc = Location(longitude: position.longitude, latitude: position.latitude, timestamp: DateTime.now());
    print(position.longitude.toString()+","+position.latitude.toString());
    return placemark;
  }

}