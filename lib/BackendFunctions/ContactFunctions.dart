
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Store.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactFunctions {

  static Future<List<MyUser>> getContacts() async {
    String s = "";
    List<Contact> contacts = (await FlutterContacts.getContacts(withProperties: true));
    int count = 0;
    contacts.forEach((element) {
      if(element.phones.length>0){
        print(element.phones.first.number);
        count++;
        s+= element.phones.first.number.replaceAll(" ", "").replaceAll("+", "");
        s+=",";
      }
    });
    return await getFriends(s);
  }

  static Future<List<MyUser>> getFriends(String phones) async {
    var res = await Store.supabase.rpc('get_users_by_phonenumbers', params: {
      "phones": phones
    }).onError((error, stackTrace) =>
    {
      print(error)
    });
    List<MyUser> users = [];
    res.forEach((element) {
      users.add(MyUser.fromMap(element));
    });
    print(res);
   // users.removeWhere((element) => element.id == Store.me.id);
    print("get users from phone: ${users.length}");
    print(users.toString());
    return users;
  }
}