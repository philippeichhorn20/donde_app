import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Store{

  static final supabase = Supabase.instance.client;

  static Position? position;
  static MyUser me = MyUser("me", "", true, "");

  static Future<void> initUser()async{
    //call after login TODO
    if(supabase.auth.currentUser != null){
      me.id = supabase.auth.currentUser!.id;
      position = await LocationServices.getUsersLocation();

    }
  }

  static Future<void> initLoc()async{
    if(supabase.auth.currentUser != null){
      position = await LocationServices.getUsersLocation();
      print(position!.latitude);
    }
  }



}