

import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Store.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class RelationshipFunctions{

  static Future<void> requestFriendship(MyUser followee, bool force)async{
     RelationshipFunctions.incrementSocialGraph(followee.id);

    print("requesting friendship");
    if(followee.relationshipType == RelationshipTypes.NONE) {
      final res = await Store.supabase.rpc(
          'requestfriendship', params: {'requestee': followee.id});
      FirebaseAnalytics.instance.logEvent(name: "adds_friend");
      followee.relationshipType = RelationshipTypes.REQUESTED_BY_ME;
    }
  }

  static Future<void> acceptFriendships(MyUser followee, bool force)async{
    RelationshipFunctions.incrementSocialGraph(followee.id);
    print("accepting friendship");
      final res = await Store.supabase.rpc('acceptfriendship', params: {'requestee': followee.id});
      FirebaseAnalytics.instance.logEvent(name: "acc_friend");
      //TODO check if res is accepted, also in backend
      followee.relationshipType = RelationshipTypes.FRIEND;
  }

  static Future<void> dropFriendRequest(MyUser followee, bool force)async{
    print("dropping request");
    final res = await Store.supabase.rpc('dropfriendrequest', params: {'requestee': followee.id});
    FirebaseAnalytics.instance.logEvent(name: "acc_friend");
    //TODO check if res is accepted, also in backend
    followee.relationshipType = RelationshipTypes.NONE;
  }

  static Future<void> declineFriendship(MyUser followee, bool force)async{
    print("declinign request");
    final res = await Store.supabase.rpc('declinefriendship', params: {'requestee': followee.id});
    FirebaseAnalytics.instance.logEvent(name: "acc_friend");
    //TODO check if res is accepted, also in backend
    followee.relationshipType = RelationshipTypes.NONE;
  }


  static Future<void> blockUser(MyUser followee, bool force)async{
    return showCupertinoModalPopup(
      context: Store.snackbarKey.currentContext!, builder: (context) {
      return CupertinoActionSheet(
        title: Text("Are you sure you want to block ${followee.username}?"),
        actions: [
          CupertinoActionSheetAction(
             isDestructiveAction: true,
            child: Text("Block"),
            onPressed: () async {
              Navigator.pop(context);
              final res = await Store.supabase.rpc('blockuser', params: {'requestee': followee.id});
              followee.relationshipType = RelationshipTypes.BLOCKED;
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    },);



  }



  static Future<MyUser> getAuthorOfReview(Review review)async{
    var res = await Store.supabase.rpc('getuserofreview', params: {'author_id': review.author.id});
    if(res.isEmpty){
      return review.author;
    }
    print("getting author of review");
    return MyUser.fromMap(res.first);
  }

  static Future<MyUser?> getUserFromId(String id)async{
    RelationshipFunctions.incrementSocialGraph(id);
    if(id.length == 36) {
      print("getting user from id");
      var res;
      try {
        res = await Store.supabase.rpc(
            'getuserofreview', params: {'author_id': id});
      }catch(e){
        return null;
      }
      if(res == null || res.length == 0){
        return null;
      }

      return MyUser.fromMap(res.first);
    }else{
      return null;
    }
  }


  static Future<void> incrementSocialGraph(String str)async{
    if(str.length == 36) {
      print("incrementing social graph");
      var res = await Store.supabase.rpc('incrementsocialgraph', params: {'user_id': str}).onError((error, stackTrace){
        print(error);
      });
      print(res);
    }
  }


  static Future<void> handleFriendshipActions(MyUser user)async{
    switch (user.relationshipType) {
      case RelationshipTypes.FRIEND:
        if(Store.snackbarKey.currentContext!= null){
          return showCupertinoModalPopup(context: Store.snackbarKey.currentContext!, builder: (context) {
            return CupertinoActionSheet(
              title: Text("Are you sure you want to unfriend ${user.username}?"),
              actions: [
                CupertinoActionSheetAction(
                  child: Text("Unfriend"),
                  onPressed: () async {
                    Navigator.pop(context);
                    await declineFriendship(user, true);
                  },
                )
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            );
          },);
        }
      //  declineFriendship(user, true);
        break;
      case RelationshipTypes.NONE:
        return await requestFriendship(user, true);
        break;
      case RelationshipTypes.REQUESTED_BY_ME:
        return await dropFriendRequest(user, true);
        break;
      case RelationshipTypes.REQUESTED_BY_OTHER:
        return await acceptFriendships(user, true);
        break;
      case RelationshipTypes.ME:
        break;
    }
  }



// old functions

/*
  static Future<void> followUser(MyUser followee, bool force)async{
    if(followee.amFollowing){
      if(force){
        await unfollowUser(followee);
      }
    }else{
      print(Store.supabase.auth.currentUser!.id);
      print(followee.id);
      final res = await Store.supabase.rpc('followuser', params: {'followee_id': followee.id});
      FirebaseAnalytics.instance.logEvent(name: "adds_friend");

      followee.amFollowing = true;
    }
  }

  static Future<void> unfollowUser(MyUser followee)async{
    print(Store.supabase.auth.currentUser!.id);
    print(followee.id);
    final res = await Store.supabase.rpc('unfollowuser', params: {'followee_id': followee.id});
    FirebaseAnalytics.instance.logEvent(name: "removes_friend_friend");

    followee.amFollowing = false;
  }

*/
}