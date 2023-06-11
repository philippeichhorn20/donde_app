import 'package:donde/BackendFunctions/ContactFunctions.dart';
import 'package:donde/BackendFunctions/FriendRelationshipGroups.dart';
import 'package:donde/BackendFunctions/GetFriends.dart';
import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Store{

  static final supabase = Supabase.instance.client;
  static final GlobalKey<ScaffoldMessengerState> snackbarKey =
  GlobalKey<ScaffoldMessengerState>();
  static Position? position;
  static PersistentTabController? pers_controller;
  static MyUser me = MyUser("me", "", "", -1);
  static Location? listViewLocation;
  static List<MyUser> friendRequests = [];
  static int openRequestsCount = 0;

  static Future<void> initUser()async{
    //call after login TODO add usernam
    if(supabase.auth.currentUser != null){
      me = await RelationshipFunctions.getUserFromId(supabase.auth.currentUser!.id)??MyUser("me", "", "", -1);
      me.id = supabase.auth.currentUser!.id;
      friendRequests = await FriendRelationshipGroups.getRequestingUsers();
      openRequestsCount = friendRequests.length;
    }
  }

  static Future<void> initLoc()async{
    if(supabase.auth.currentUser != null){
      position = await LocationServices.getUsersLocation();
    }
  }

static Location? getListViewLocation(){
    if(listViewLocation != null){
      return listViewLocation;
    }
    if(position != null){
      return Location(latitude: position!.latitude, longitude: position!.longitude, timestamp: DateTime.now());
    }
    Location(latitude: 50, longitude: -10, timestamp: DateTime.now());
}
}