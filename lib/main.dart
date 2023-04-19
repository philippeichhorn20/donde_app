import 'package:donde/BackendFunctions/Linking.dart';
import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/UI/IntroFlow/SignUp.dart';
import 'package:donde/UI/IntroFlow/Welcome.dart';
import 'package:donde/UI/MainViews/HomePage.dart';
import 'package:donde/UI/MainViews/Skeleton.dart';
import 'package:donde/Store.dart';
import 'package:donde/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Supabase.initialize(
    url: "https://zgrgtiatjryryowqwhhi.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpncmd0aWF0anJ5cnlvd3F3aGhpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzkyMzgxNzAsImV4cCI6MTk5NDgxNDE3MH0.jZqek_ImEiQpkR8WJ-XD7yPoSxzC12aGIhH3NN46xh0",
  );
  OneSignal.shared.setAppId("2ecfeae4-3aa7-4e3c-9bc2-ee22c018cd57");

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = await SignUpFunctions.logInFromStorage();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if(isLoggedIn){
    await Store.initLoc();
  }
  runApp(MyApp(isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  const MyApp(this.isLoggedIn);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        color: Colors.black45,
        theme: ThemeData.dark(),
        home:  Scaffold(
          key: Store.snackbarKey,
          body: widget.isLoggedIn ? Skeleton():Welcome(),),
      ),
    );
  }
}

