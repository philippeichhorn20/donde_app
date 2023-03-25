import 'package:donde/Classes/MyUser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Store{

  static final supabase = Supabase.instance.client;


  static MyUser me = MyUser("me", "", true, "");

  void initUser(){
    //call after login TODO
    if(supabase.auth.currentUser != null){
      me.id = supabase.auth.currentUser!.id;

    }
  }

}