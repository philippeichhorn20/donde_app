import 'package:camera/camera.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:flutter/material.dart';

class Review{


  String text;
  double? textColor;
  MyUser author;
  XFile? image;
  Spot spot;
  bool liked = false;
  int? id = 7;
  DateTime? createdAt;

  Review(this.text, this.author, this.spot, this.liked);

  static Review fromMap(Map<String, dynamic> spotMap, Spot spot){
    print(spotMap);
    Review review = Review(spotMap.remove("description"), MyUser("", "", false, spotMap.remove("author")), spot, false/*todo*/);
    review.textColor = spotMap.remove("textcolor");
    review.createdAt = DateTime.tryParse(spotMap.remove("created_at"));
    return review;
  }
}