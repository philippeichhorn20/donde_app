import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/IntroFlow/SignUp.dart';
import 'package:donde/IntroFlow/Welcome.dart';
import 'package:donde/MainViews/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://zgrgtiatjryryowqwhhi.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpncmd0aWF0anJ5cnlvd3F3aGhpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzkyMzgxNzAsImV4cCI6MTk5NDgxNDE3MH0.jZqek_ImEiQpkR8WJ-XD7yPoSxzC12aGIhH3NN46xh0",
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = false;//await SignUpFunctions.logInFromStorage();
  runApp(
      MaterialApp(
        color: Colors.black45,
        theme: ThemeData.dark(),
        home:  isLoggedIn ? HomePage():Welcome(),
  ));
}
