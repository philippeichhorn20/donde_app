

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Store.dart';

class ReviewFunctions{

  static Future<bool> saveReview(Review review)async{
    if(review.image == null){
      return false;
    }
    int res = await Store.supabase.rpc('savereview',
        params: {
          'spot': review.spot.id,
          'liked': review.liked,
          'textcolor': review.textColor,
          'description': review.text,
          'author': Store.supabase.auth.currentUser!.id,
        });
    review.id = res;
    if(res != 0){
      File file = File(review.image!.path);
      final storageResponse = await Store.supabase
          .storage
          .from('reviewpics')
          .upload('${res.toString()}',file);
      return true;
    }
    return false;
  }


  static Future<List<Review>> getReviews(Spot spot)async{
    print("here");
    var res = await Store.supabase.rpc('getreviews',params: {
      "spot": spot.id,
    });
    List<Review> reviews = [];
    res.forEach((element) {
      reviews.add(Review.fromMap(element, spot));
    });
    print(reviews.length);
    return reviews;
  }

  static Future<Uint8List?> getReviewPic(Review review)async{
    if(review.id !=null){
      Uint8List data = await Store.supabase.storage
            .from("reviewpics")
            .download(review.id.toString());
      return data;
    }
  }


}