import 'dart:math';

import 'package:donde/Classes/RawSpot.dart';
import 'package:donde/Store.dart';
import 'package:donde/UI/IntroFlow/LocationPermissionView.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class LocationServices{





  static Future<Position?> getUsersLocation()async{
    bool serviceEnabled;
    LocationPermission permission;
    try{
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();


    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
      }
    }


      Store.position = await Geolocator.getCurrentPosition();
    }catch (e){

      Store.position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
    }


    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    print("getting users location: ${Store.position?.latitude}, ${Store.position?.longitude}");

    return Store.position;
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


  static Future<RawSpot?> getAdressOfCurrentLocation()async{
    Position? position = await getUsersLocation();
    if(position == null){
      return null;
    }
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark? placemark = placemarks.first;
    if(placemarks.isEmpty || placemark.country == null){
      return null;
    }else{
      RawSpot rawSpot = RawSpot();
      rawSpot.adress = "${placemark.street}, ${placemark.locality}";
      rawSpot.latlong = Location(latitude: position.latitude, longitude: position.longitude, timestamp: DateTime.now());
      rawSpot.title = "Your current location";
      return rawSpot;
    }
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