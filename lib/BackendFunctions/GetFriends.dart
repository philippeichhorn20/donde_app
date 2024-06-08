import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Store.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class GetFriends{



  static Future<List<MyUser>> getFriendsFromContact(String contact)async{
    var res = await Store.supabase.rpc('getuserstest',).onError((error, stackTrace)  {
      print(error);
      print(stackTrace.toString());
    });
    List<MyUser> users = [];

    res.forEach((element) {
      users.add(MyUser.fromMap(element));
    });
    FirebaseAnalytics.instance.logEvent(name: "uses_proposals", parameters: {
      "result":users.length
    });
    //users.removeWhere((element) => element.id == Store.me.id);
    print("userstest: ${users.length}");
    return users;
}




  static Future<List<MyUser>> getPeopleThatFollowMe()async{

    var res = await Store.supabase.rpc('getfollowed',).onError((error, stackTrace) => {
      print(error)
    });

    List<MyUser> users = [];

    res.forEach((element) {
      users.add(MyUser.fromMap(element));
    });
    FirebaseAnalytics.instance.logEvent(name: "searches_followers", parameters: {
      "result":users.length
    });
    users.removeWhere((element) => element.id == Store.me.id);
    print("getfollowed: ${users.length}");

    return users;
  }



  static Future<List<MyUser>> getreactingusers(Review review,Reactions reaction )async{

    var res = await Store.supabase.rpc('getreactingusers',
    params: {
      "review":review.id,
      "reaction":reaction.name
    }
    );

    print(res.toString());
    List<MyUser> users = [];

    res.forEach((element) {
      users.add(MyUser.fromMap(element));
    });

    print("getreactingusers: ${users.length}");

    return users;
  }

  static Future<List<MyUser>> getUserFromString(String str)async{
    if(str.isEmpty || str == ""){
      return getFriendsFromContact("");
    }
    var res = await Store.supabase.rpc('getuserfromstring',params:
    {
      "str":str
    }).onError((error, stackTrace) => {
      print(error)
    });

    List<MyUser> users = [];

    res.forEach((element) {
      print(element.toString());
      users.add(MyUser.fromMap(element));
    });
    users.removeWhere((element) => element.id == Store.me.id);
    print("getuserfromstring: ${users.length}");
    return users;
  }



//deprecated
  static Future<List<MyUser>> getPeopleIFollow()async{
    var res = await Store.supabase.rpc('getfollowing',).onError((error, stackTrace) => {
      print(error)
    });
    List<MyUser> users = [];

    res.forEach((element) {
      users.add(MyUser.fromMap(element));
    });
    FirebaseAnalytics.instance.logEvent(name: "searches_following", parameters: {
      "result":users.length
    });
    users.removeWhere((element) => element.id == Store.me.id);
    print("getfollowing: ${users.length}");
    return users;
  }



}