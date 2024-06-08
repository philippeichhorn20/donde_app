



import 'dart:io';

import 'package:camera/camera.dart';
import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Store.dart';

class ReviewFunctions{

  static Future<bool> saveReview(Review review)async{
    print("saving review");
    if(review.image == null){
      return false;
    }
    int res = await Store.supabase.rpc('savereview',
        params: {
          'spot': review.spot!.id,
          'liked': false,
          'textcolor': review.textColor,
          'description': review.text,
          'author': Store.supabase.auth.currentUser!.id,
          "rating":review.rating??0,
        });
    review.id = res;
    if(res != 0){
      File file = review.image!;
      final storageResponse = await Store.supabase
          .storage
          .from('reviewpics/reviewpics/public/')
          .upload(res.toString(),file);
      if(Store.snackbarKey.currentContext!=null){
        UITemplates.showErrorMessage(Store.snackbarKey.currentContext!, "Your review has been added!\nRefresh the feed to see it");
      }
      return true;
    }
    return false;
  }


  static Future<List<Review>> getReviews(Spot spot)async{

    var res = await Store.supabase.rpc('getreviews2',params: {
      "spot": spot.id,
    });
    List<Review> reviews = [];

    await Future.forEach(res,(element) async{
      Review review = Review.fromMap(element as Map<String, dynamic>, spot);
      review.author = await RelationshipFunctions.getAuthorOfReview(review);
      reviews.add(review);
    });
    spot.reviews = reviews;
    return reviews;
  }

  static Future<Uint8List?> getReviewPic(Review review)async{
if(review.isDeleted){
  return null;
}
  if(review.pic != null){
    print("getting stored one");
    return review.pic;
  }
  print("getting not stored one");

  if(review.id !=null && review.id != 0){
    Uint8List data = await Store.supabase.storage
        .from("reviewpics")
        .download("reviewpics/public/"+review.id.toString());
    print("done");
    review.pic = data;
    print("loading review pic");
    return data;

  }
  }

  static Future<List<Review>> getMyReviews()async{
    var res = await Store.supabase.rpc('getmyreviews',params: {
    });
    List<Review> reviews = [];

    await Future.forEach(res,(element) async{

      Review review = Review.fromMap(element as Map<String, dynamic>, Spot("", 0, 0, "", "", SpotTypes.Spot));
      review.author = await RelationshipFunctions.getAuthorOfReview(review);

      reviews.add(review);
    });
    print("get my reviews: ${reviews.length}");
    return reviews;
  }

  static Future<bool> deleteReview(Review rev) async{
    //todo: return
    var res = await Store.supabase.rpc('deletereview',
        params: {
          'reviewid': rev.id,
        }).onError((error, stackTrace) => false);
    final storageResponse = await Store.supabase
    .storage
        .from("reviewpics")
        .remove(["reviewpics/public/"+rev.id.toString()]);
    return true;
  }



  static Future<bool> reportReview(Review rev, String subject) async{
    var res = await Store.supabase.rpc('report',
        params: {
          'object': rev.id,
          'subject':subject
        }).onError((error, stackTrace) => false);
    print("reporting review");
    return true;
  }


  static Future<void> incrementReaction(Reactions reaction, Review review)async{
    print("incre");
    var res = await Store.supabase.rpc('incrementreaction',
        params: {
          'review': review.id,
          'type':reaction.name
        }).onError((error, stackTrace) {
      print(stackTrace);

    });
  }


  static Future<void> decrementReaction(Reactions reaction, Review review)async{
    print("decre");
    var res = await Store.supabase.rpc('decrementreaction',
        params: {
          'review': review.id,
          'type':reaction.name
        }).onError((error, stackTrace) {
          print(stackTrace);
    });
  }
}