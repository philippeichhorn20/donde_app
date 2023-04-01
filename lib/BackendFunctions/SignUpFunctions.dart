import 'package:donde/Store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SignUpFunctions{


  static Future<User?> signUp(String phone, password, username)async{
    print(phone.replaceAll(" ", ""));
    print(password);
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
    Store.initUser();
    return user;
  }


  static Future<bool> logIn(String phone, password)async{
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

    return res.user != null;
  }

  static Future<bool> logInFromStorage()async{
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
    return res.user != null;
  }


  static Future<void> signOut()async{
    SharedPreferences inst = await SharedPreferences.getInstance();
    inst.clear();
    await Store.supabase.auth.signOut();
  }


}