import 'package:donde/Classes/Review.dart';

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
    spot.lat = spotMap.remove("lat");
    spot.long = spotMap.remove("long");
    return spot;

  }



}


enum SpotTypes{
  Restaurant, Bar, Club, Stay, Spot, Culture, Nature,
}