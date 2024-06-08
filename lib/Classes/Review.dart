

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
  bool isDeleted = false;

  //review reactions
  bool iHeart = false;
  bool iveBeen = false;
  bool iLoveIt = false;

  int heartCount = 7;
  int beenCount = 7;
  int loveCount = 7;

  Review(this.text, this.author, this.spot, this.rating);

  static Review fromMap(Map<String, dynamic> spotMap, Spot spot){

    Review review = Review(spotMap.remove("description"), MyUser("", "", spotMap.remove("author"), 0), spot, 1);
    review.textColor = spotMap.remove("textcolor").toDouble();
    review.createdAt = DateTime.tryParse(spotMap.remove("created_at"));
    review.id = spotMap.remove("id");
    review.rating = spotMap.remove("rating")??0;

    print(spotMap.toString());

     review.iHeart = (spotMap.remove("iheart")??0)>0;
     review.iveBeen = (spotMap.remove("ibeen")??0)>0;
     review.iLoveIt = (spotMap.remove("ilove")??0)>0;

     review.loveCount = spotMap.remove("lovecount")??0;
     review.heartCount = spotMap.remove("heartcount")??0;
     review.beenCount = spotMap.remove("beencount")??0;

    return review;
  }

  static Future<Review?> addReview(String text, Spot spot, int rating, double valueSlider, File? pic) async {
    Review review = Review(text, Store.me, spot, rating);
    review.textColor = valueSlider;
    review.image = pic;
    return review;
  }

  void iChangeMind(Reactions reaction)async{
    switch (reaction){
      case Reactions.HEART:
        if(iHeart){
          heartCount--;
          ReviewFunctions.decrementReaction(reaction, this);
        }else{
          heartCount++;
          ReviewFunctions.incrementReaction(reaction, this);

        }
        iHeart = !iHeart;
        break;
      case Reactions.BEEN:
        if(iveBeen){
          beenCount--;
          ReviewFunctions.decrementReaction(reaction, this);

        }else{
          beenCount++;
          ReviewFunctions.incrementReaction(reaction, this);
        }
        iveBeen = !iveBeen;
        break;
      case Reactions.LOVE:
        if(iLoveIt){
          loveCount--;
          ReviewFunctions.decrementReaction(reaction, this);

        }else{
          loveCount++;
          ReviewFunctions.incrementReaction(reaction, this);

        }
        iLoveIt = !iLoveIt;

        break;
    }
  }
}

enum Reactions{
  HEART, BEEN, LOVE
}