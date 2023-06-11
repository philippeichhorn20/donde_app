import 'package:geocoding/geocoding.dart';

class RawSpot{
  String adress = "";
  String name = "";
  Location? latlong;

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


  RawSpot();



  @override
  String toString() {
    // TODO: implement toString
    return "$name in $adress";
  }
}