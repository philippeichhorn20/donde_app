

import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Store.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class RelationshipFunctions{

  static Future<void> followUser(MyUser followee)async{
    if(followee.amFollowing){
      await unfollowUser(followee);
    }else{
      print(Store.supabase.auth.currentUser!.id);
      print(followee.id);
      final res = await Store.supabase.rpc('followuser', params: {'followee_id': followee.id});
      FirebaseAnalytics.instance.logEvent(name: "adds friend");

      followee.amFollowing = true;
    }
  }

  static Future<void> unfollowUser(MyUser followee)async{
    print(Store.supabase.auth.currentUser!.id);
    print(followee.id);
    final res = await Store.supabase.rpc('unfollowuser', params: {'followee_id': followee.id});
    FirebaseAnalytics.instance.logEvent(name: "removes friend friend");

    followee.amFollowing = false;
  }

  static Future<MyUser> getAuthorOfReview(Review review)async{
    print("lol");
    var res = await Store.supabase.rpc('getuserofreview', params: {'author_id': review.author.id});
    print("he111re");
    print(res.toString());
    if(res.isEmpty){
      return review.author;
    }
    return MyUser.fromMap(res.first);
  }

  static Future<MyUser?> getUserFromId(String id)async{
    if(id.length == 36) {
      print("lol");
      print("pattern matching");
      var res;

      try {
        res = await Store.supabase.rpc(
            'getuserofreview', params: {'author_id': id});
        print("he111re");
        print(res.toString());
      }catch(e){
        return null;
      }
      if(res == null || res.length == 0){
        return null;
      }

      return MyUser.fromMap(res.first);
    }else{
      print("pattern not matching");
      print(id.length);
      return null;
    }
  }


  static Future<void> incrementSocialGraph(String str)async{
    var res = await Store.supabase.rpc('incrementsocialgraph', params: {'user_id': str});
  }



}