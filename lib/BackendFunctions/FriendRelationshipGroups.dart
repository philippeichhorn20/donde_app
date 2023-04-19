import 'package:firebase_analytics/firebase_analytics.dart';

import '../Classes/MyUser.dart';
import '../Store.dart';

class FriendRelationshipGroups{

  static Future<List<MyUser>> getRequestingUsers()async{
    var res = await Store.supabase.rpc('getfriendrequests',).onError((error, stackTrace) => {
      print(error)
    });
    List<MyUser> users = [];

    res.forEach((element) {
      MyUser user = MyUser.fromMap(element);
      user.relationshipType = RelationshipTypes.REQUESTED_BY_OTHER;
      users.add(user);
    });
    FirebaseAnalytics.instance.logEvent(name: "searches_followers", parameters: {
      "result":users.length
    });
    users.removeWhere((element) => element.id == Store.me.id);
    print("requesting users: ${users.length}");

    return users;
  }


  static Future<List<MyUser>> getPeopleIRequested()async{
    var res = await Store.supabase.rpc('getpeopleirequested',).onError((error, stackTrace) => {
      print(error)
    });
    List<MyUser> users = [];
    res.forEach((element) {
      print(element.toString());
      MyUser user = MyUser.fromMap(element);
      user.relationshipType = RelationshipTypes.REQUESTED_BY_ME;
      users.add(user);
    });
    FirebaseAnalytics.instance.logEvent(name: "searches_followers", parameters: {
      "result":users.length
    });
    users.removeWhere((element) => element.id == Store.me.id);
    print("requested users: ${users.length}");
    return users;
  }



  static Future<List<MyUser>> getFriends()async{
    var res = await Store.supabase.rpc('getfriends',).onError((error, stackTrace) => {
      print(error)
    });

    List<MyUser> users = [];
    res.forEach((element) {
      print(element.toString());
      MyUser user = MyUser.fromMap(element);
      users.add(user);
    });
    FirebaseAnalytics.instance.logEvent(name: "searches_followers", parameters: {
      "result":users.length
    });
    users.removeWhere((element) => element.id == Store.me.id);
    print("friended users: ${users.length}");
    return users;
  }
}