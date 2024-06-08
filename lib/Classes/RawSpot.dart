import 'package:geocoding/geocoding.dart';

class RawSpot{
  String adress = "";
  String name = "";
  Location? latlong;
  String? title;

  RawSpot.fromMap(Map<String,dynamic> map){
  //  print(map.toString());
    Map<String, dynamic>? poiMap = map.remove("poi");
    name = poiMap?.remove("name")??"";
    Map<String, dynamic> adressMap = map.remove("address");
    String street = adressMap.remove("streetName")??"";
    String number = adressMap.remove("streetNumber")??"";
    String city = adressMap.remove("municipality");

    adress = (street == ""? "":"${street} ${number}, ")+"${city}";
    Map<String, dynamic> position = map.remove("position");
    double lat = position.remove("lat");
    double long = position.remove("lon");
    latlong = Location(latitude: lat, longitude: long, timestamp: DateTime.now());
  }

  static RawSpot? fromAppleMap(Map<String,dynamic> map){
    //  print(map.toString());
    RawSpot spot = RawSpot();
    List<String> displayNames = map.remove("displayLines")??[];
    if(displayNames.length == 2){
      spot.name = displayNames[0];
    spot.adress = displayNames[2];
    }else{
      return null;
    }
    Map<String, dynamic> position = map.remove("location");
    double? lat = position.remove("lat");
    double? long = position.remove("lng");
    if(lat == null && long == null){
      return null;
    }
    spot.latlong = Location(latitude: lat!, longitude: long!, timestamp: DateTime.now());
    return spot;
  }

  RawSpot();



  @override
  String toString() {
    // TODO: implement toString
    return "$name in $adress";
  }
}