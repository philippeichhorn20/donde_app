import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Store{

  static final supabase = Supabase.instance.client;

  static Position? position;
  static MyUser me = MyUser("me", "", true, "");
  static Location? listViewLocation;

  static Future<void> initUser()async{
    //call after login TODO
    if(supabase.auth.currentUser != null){
      me.id = supabase.auth.currentUser!.id;
      position = await LocationServices.getUsersLocation();
    }
  }

  static Future<void> initLoc()async{
    print("initialising djbk");

    if(supabase.auth.currentUser != null){
      print("initialising eoiwj");

      position = await LocationServices.getUsersLocation();
      print("initialising location");
      print(position!.latitude);
    }
  }

static Location? getListViewLocation(){
    if(listViewLocation != null){
      return listViewLocation;
    }
    if(position != null){
      return Location(latitude: position!.latitude, longitude: position!.longitude, timestamp: DateTime.now());
    }

}

}