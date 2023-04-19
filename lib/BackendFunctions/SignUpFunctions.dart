import 'package:donde/Store.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SignUpFunctions{


  static Future<User?> signUp(String phone, password, username)async{
    final AuthResponse res = await Store.supabase.auth.signUp(
      phone: phone.replaceAll(" ", ""),
      password: password,
    );

    final Session? session = res.session;
    final User? user = res.user;
    SharedPreferences inst = await SharedPreferences.getInstance();
    if(user != null){
      await Store.supabase.rpc('newuser',
          params: {
            'userid': res.user!.id,
            'username': username,
          });

      inst.setString("phone",phone.replaceAll(" ", "") );
      inst.setString("password",password);
    }
    if(user != null){
      OneSignal.shared.setExternalUserId(user.id);
    }
    Store.initUser();
    return user;
  }


  static Future<bool> logIn(String phone, password)async{
try{
  final AuthResponse res = await Store.supabase.auth.signInWithPassword(
    phone: phone.replaceAll(" ", ""),
    password: password,
  );
  final Session? session = res.session;
  final User? user = res.user;
  SharedPreferences inst = await SharedPreferences.getInstance();
  inst.setString("phone",phone.replaceAll(" ", "") );
  inst.setString("password",password);
  Store.initUser();
  if(user != null){
    OneSignal.shared.setExternalUserId(user.id);
  }
  return res.user != null;
}catch (e){
  return false;
}
  }

  static Future<bool> logInFromStorage()async{
    print("remote login");
    SharedPreferences inst = await SharedPreferences.getInstance();
    String? password = inst.getString("password");
    String? phone = inst.getString("phone");
    if(phone == null || password == null){
      return false;
    }

    final AuthResponse res = await Store.supabase.auth.signInWithPassword(
      phone: phone,
      password: password,
    );
    final Session? session = res.session;
    final User? user = res.user;
    Store.initUser();
    if(user != null){
      OneSignal.shared.setExternalUserId(user.id);
    }

    return res.user != null;
  }


  static Future<void> signOut()async{
    SharedPreferences inst = await SharedPreferences.getInstance();
    inst.clear();
    OneSignal.shared.setExternalUserId("");

    await Store.supabase.auth.signOut();
  }

  static Future<bool> deleteUser()async{
    SharedPreferences inst = await SharedPreferences.getInstance();
    inst.clear();
    bool success = true;
    if(Store.supabase.auth.currentUser!=null){
      String id = Store.supabase.auth.currentUser!.id;
      await Store.supabase.auth.admin.deleteUser(id).onError((error, stackTrace) {
        success = false;
      });

    }else{
      success = false;
    }
    if(success){
      OneSignal.shared.setExternalUserId("");
    }

    return success;
  }


}