

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Review{


  String text;
  double? textColor;
  MyUser author;
  File? image;
  Spot? spot;
  int? id;
  DateTime? createdAt;
  Uint8List? pic;
  int? rating;

  Review(this.text, this.author, this.spot, this.rating);

  static Review fromMap(Map<String, dynamic> spotMap, Spot spot){

    Review review = Review(spotMap.remove("description"), MyUser("", "", spotMap.remove("author"), 0), spot, 1);
    review.textColor = spotMap.remove("textcolor").toDouble();
    review.createdAt = DateTime.tryParse(spotMap.remove("created_at"));
    review.id = spotMap.remove("id");
    review.rating = spotMap.remove("rating")??0;

    return review;
  }

  static Future<Review?> addReview(String text, Spot spot, int rating, double valueSlider, File? pic) async {
    Review review = Review(text, Store.me, spot, rating);
    review.textColor = valueSlider;
    review.image = pic;
    return review;
  }
}