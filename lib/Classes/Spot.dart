import 'dart:convert';

import 'package:donde/Classes/Review.dart';
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
    print("h1ere");

  try {

    String point = spotMap.remove("latlong")??"1 1";
    print("h1ere");
    int length = point.length;
    print("he2re");

    List<String> points = point.substring(6, length-1).split(" ");
    print("he3re");

    spot.lat = (double.tryParse(points[0]))??0;
    print("he4re");

    spot.long = (double.tryParse(points[1]))??0;
  } catch(e) {
print(e);
  }

    return spot;

  }




}


enum SpotTypes{
  Restaurant, Bar, Club, Stay, Spot, Culture, Nature, Other,

}