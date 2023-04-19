import 'dart:math';

import 'package:donde/Store.dart';
import 'package:donde/UI/IntroFlow/LocationPermissionView.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class LocationServices{





  static Future<Position?> getUsersLocation()async{
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if(Store.snackbarKey.currentContext != null){
        Navigator.of(Store.snackbarKey.currentContext!).push(
          CupertinoPageRoute(
            builder: (context) => LocationPermissionView(),
          ),
        );
        return null;
      }

    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

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
    print("getting users location: ${Store.position?.latitude}, ${Store.position?.longitude}");

    return Store.position!;
  }


  static Future<List<Location>> getLocationsFromString(String str)async{
    List<Location> locs = await locationFromAddress(str).onError((error, stackTrace) => []);
    print("location from adress string ${locs.length}");
    return locs;
  }

  static String getDistance(Location location){
    if(Store.position != null) {
      return distanceToString(Geolocator.distanceBetween(
        location.latitude, location.longitude, Store.position!.latitude,
        Store.position!.longitude,).toInt());
    }
    return "not found";
  }

  static int getDistanceNum(Location location){
    if(Store.position != null) {
      return (Geolocator.distanceBetween(
        location.latitude, location.longitude, Store.position!.latitude,
        Store.position!.longitude,).toInt());
    }
    return 0;
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

    return atan2(lat, long);
  }


  static Future<Placemark?> getAdressOfCurrentLocation(Location loc)async{
    Position? position = await getUsersLocation();
    if(position == null){
      return null;
    }
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark? placemark = placemarks.first;
    loc = Location(longitude: position.longitude, latitude: position.latitude, timestamp: DateTime.now());
    return placemark;
  }


  Future<Map<Placemark,Location>> getPlacemarkFromAdress(String str)async{

    List<Location> locations = await LocationServices.getLocationsFromString(str);
    Map<Placemark,Location> countriesMaps = {};
    await Future.forEach(locations, (element) async {
      Placemark? countryStr = (await placemarkFromCoordinates(element.latitude, element.longitude)).first;
      if(countryStr!=null){
        countriesMaps.addAll({countryStr:element});
      }
    });
    return countriesMaps;
  }



}