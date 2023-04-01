
import 'package:camera/camera.dart';
import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Review{


  String text;
  double? textColor;
  MyUser author;
  XFile? image;
  Spot spot;
  bool liked = false;
  int? id;
  DateTime? createdAt;
  Uint8List? pic;

  Review(this.text, this.author, this.spot, this.liked);

  static Review fromMap(Map<String, dynamic> spotMap, Spot spot){

    Review review = Review(spotMap.remove("description"), MyUser("", "", false, spotMap.remove("author")), spot, false/*todo*/);
    review.textColor = spotMap.remove("textcolor").toDouble();
    review.createdAt = DateTime.tryParse(spotMap.remove("created_at"));
    review.id = spotMap.remove("id");

    return review;
  }
}