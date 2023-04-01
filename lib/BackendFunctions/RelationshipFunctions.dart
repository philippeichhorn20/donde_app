

import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Store.dart';

class RelationshipFunctions{

  static Future<void> followUser(MyUser followee)async{
    if(followee.amFollowing){
      await unfollowUser(followee);
    }else{
      print(Store.supabase.auth.currentUser!.id);
      print(followee.id);
      final res = await Store.supabase.rpc('followuser', params: {'followee_id': followee.id});
      followee.amFollowing = true;
    }
  }

  static Future<void> unfollowUser(MyUser followee)async{
    print(Store.supabase.auth.currentUser!.id);
    print(followee.id);
    final res = await Store.supabase.rpc('unfollowuser', params: {'followee_id': followee.id});
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


  static Future<MyUser?> getUserFromId(String str)async{
    print("lol");
    var res = await Store.supabase.rpc('getuserofreview', params: {'author_id': str});
    print("he111re");
    print(res.toString());
    if(res.isEmpty){
      return null;
    }
    return MyUser.fromMap(res.first);
  }



}