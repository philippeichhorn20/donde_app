import 'dart:convert';

import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/Classes/Review.dart';
import 'package:geocoding/geocoding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Spot{

  List<Review>? reviews;
   String name;
  int likes;
  int dislikes;
  String adress;
String description;
double? long;
double? lat;
SpotTypes type;
int? id;
  Spot(this.name, this.likes, this.dislikes, this.adress, this.description, this.type);

  static Spot fromMap(Map<String, dynamic> spotMap){
    Spot spot = Spot(spotMap.remove("name"), 0, 0, spotMap.remove("adress"), spotMap.remove("description"), SpotTypes.values[spotMap.remove("type")]);

    spot.id = spotMap.remove("id");
   // dislikes = spotMap.remove("name");
  //  likes = spotMap.remove("name");

  try {

    String point = spotMap.remove("latlong")??"1 1";
    int length = point.length;

    List<String> points = point.substring(6, length-1).split(" ");

    spot.lat = (double.tryParse(points[0]))??0;

    spot.long = (double.tryParse(points[1]))??0;
  } catch(e) {
print(e);
  }

    return spot;

  }



  String getDistance(){
    Location loc = Location(latitude: lat!, longitude: long!, timestamp: DateTime.now());
    return LocationServices.getDistance(loc);
  }

}


enum SpotTypes{
  Restaurant, Bar, Club, Stay, Spot, Culture, Nature, Other,

}