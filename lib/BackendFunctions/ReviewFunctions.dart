

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
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
          .from('reviewpics/reviewpics/public/')
          .upload('${res.toString()}',file);
      return true;
    }
    return false;
  }


  static Future<List<Review>> getReviews(Spot spot)async{
    var res = await Store.supabase.rpc('getreviews',params: {
      "spot": spot.id,
    });
    List<Review> reviews = [];
    print(res.first.runtimeType.toString());

    await Future.forEach(res,(element) async{

      Review review = Review.fromMap(element as Map<String, dynamic>, spot);
      review.author = await RelationshipFunctions.getAuthorOfReview(review);

      reviews.add(review);
    });
    spot.reviews = reviews;
    return reviews;
  }

  static Future<Uint8List?> getReviewPic(Review review)async{
    if(review.pic != null){
      return review.pic;
    }
    if(review.id !=null){
      print("reviewid");
      print(review.id);

      Uint8List data = await Store.supabase.storage
            .from("reviewpics")
            .download("reviewpics/public/"+review.id.toString());
      review.pic = data;
      return data;
    }
  }


  static Future<bool> deleteReview(Review rev) async{
    //todo: return
    var res = await Store.supabase.rpc('deletereview',
        params: {
          'reviewid': rev.id,
        }).onError((error, stackTrace) => false);
    return true;
  }

}