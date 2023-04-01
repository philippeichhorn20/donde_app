import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Store.dart';

class GetFriends{



  static Future<List<MyUser>> getFriendsFromContact(String contact)async{
    print("function called");
    var res = await Store.supabase.rpc('getuserstest',).onError((error, stackTrace) => {
      print(error)
    });
    print("function finished");
    List<MyUser> users = [];

    print(Store.supabase.auth.currentUser!.id);
    res.forEach((element) {
      print(element.toString());
      users.add(MyUser.fromMap(element));
    });
    print(res.length);
    return users;
}

  static Future<List<MyUser>> getPeopleIFollow()async{
    print("function called I follo");
    var res = await Store.supabase.rpc('getfollowing',).onError((error, stackTrace) => {
      print(error)
    });
    print("function finished");
    List<MyUser> users = [];
    print(res.length);

    res.forEach((element) {
      print(element.toString());
      users.add(MyUser.fromMap(element));
      print("user added");
    });
    return users;
  }

  static Future<List<MyUser>> getPeopleThatFollowMe()async{
    print("function called follow me");
    var res = await Store.supabase.rpc('getfollowed',).onError((error, stackTrace) => {
      print(error)
    });
    print(Store.supabase.auth.currentUser!.id);

    print("function finished");
    List<MyUser> users = [];
    print(res.length);

    res.forEach((element) {
      print(element.toString());
      users.add(MyUser.fromMap(element));
      print("user added");

    });
    return users;
  }

  static Future<List<MyUser>> getUserFromString(String str)async{
    if(str.isEmpty || str == ""){
      print("function opting to props");

      return getFriendsFromContact("");
    }
    print("function called getuserFromstring me");
    var res = await Store.supabase.rpc('getuserfromstring',params:
    {
      "str":str
    }).onError((error, stackTrace) => {
      print(error)
    });

    print("function finished");
    List<MyUser> users = [];
    print(res.length);

    res.forEach((element) {
      print(element.toString());
      users.add(MyUser.fromMap(element));
      print("user added");

    });
    return users;
  }




}