import 'package:donde/Store.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SignUpFunctions{


  static Future<User?> signUp(String phone, password, username, uusername)async{
    final AuthResponse res = await Store.supabase.auth.signUp(
      phone: phone.replaceAll(" ", ""),
      password: password,
    );

    final Session? session = res.session;
    final User? user = res.user;
    SharedPreferences inst = await SharedPreferences.getInstance();
    if(user != null){
      await Store.supabase.rpc('newuser2',
          params: {
            'userid': res.user!.id,
            'username': username,
            "unique_username":uusername.toLowerCase()
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

  static Future<LogInState> logInFromStorage()async{
try{
  await Supabase.initialize(
    url: "https://zgrgtiatjryryowqwhhi.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpncmd0aWF0anJ5cnlvd3F3aGhpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzkyMzgxNzAsImV4cCI6MTk5NDgxNDE3MH0.jZqek_ImEiQpkR8WJ-XD7yPoSxzC12aGIhH3NN46xh0",
  );
}catch(e){

}



    print("remote login");
    SharedPreferences inst = await SharedPreferences.getInstance();
    String? password = inst.getString("password");
    String? phone = inst.getString("phone");
    if(phone == null || password == null){
      return LogInState.LOGGED_OUT;
    }

try{
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
  return res.user == null? LogInState.LOGGED_OUT:LogInState.LOGGED_IN;

}catch(e){
     return LogInState.NO_COONECTION;
}


  }



  static Future<bool> checkUniqueness(String uusername ) async{
    var res = await Store.supabase.rpc('checkuniqueness',
        params: {
          'unique_username': uusername.toLowerCase(),
        }).onError((error, stackTrace) => false);
    return res  == 0;
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
    var res = await Store.supabase.rpc('deleteuser', params: {'user_id': Store.me.id});
      OneSignal.shared.setExternalUserId("");
    return success;
  }
  static Future<bool> changeDetails(String uusername, name)async{
    bool success = true;
    print("changing");
    var res = await Store.supabase.rpc('changedetails', params: {'user_id': "",'unique_username':uusername,'username': name, });
    print("change success");


    //make sure success
    return res == false ? false:true;
  }

}

enum LogInState{
  LOGGED_IN,LOGGED_OUT,NO_COONECTION
}