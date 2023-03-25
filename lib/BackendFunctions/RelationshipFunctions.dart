

import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Store.dart';

class RelationshipFunctions{

  static Future<void> followUser(MyUser followee)async{
    print(Store.supabase.auth.currentUser!.id);
    print(followee.id);
    final res = await Store.supabase.rpc('followuser', params: {'followee': followee.id});
  followee.amFollowing = true;
  }

  static Future<void> unfollowUser(MyUser followee)async{
    print(Store.supabase.auth.currentUser!.id);
    print(followee.id);
    final res = await Store.supabase.rpc('unfollowuser', params: {'followee': followee.id});
    followee.amFollowing = false;
  }

}