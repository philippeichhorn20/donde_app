import 'package:donde/BackendFunctions/Linking.dart';
import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/UI/IntroFlow/NoConnectionView.dart';
import 'package:donde/UI/IntroFlow/SignUp.dart';
import 'package:donde/UI/IntroFlow/Welcome.dart';
import 'package:donde/UI/MainViews/HomePage.dart';
import 'package:donde/UI/MainViews/Skeleton.dart';
import 'package:donde/Store.dart';
import 'package:donde/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);


  OneSignal.shared.setAppId("2ecfeae4-3aa7-4e3c-9bc2-ee22c018cd57");


  final SharedPreferences prefs = await SharedPreferences.getInstance();
  LogInState isLoggedIn = await SignUpFunctions.logInFromStorage().timeout(Duration(seconds: 5), onTimeout: () {
    print("timeout");
    return LogInState.NO_COONECTION;
  },).onError((error, stackTrace) => LogInState.NO_COONECTION);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  if(isLoggedIn == LogInState.LOGGED_IN){
    await Store.initLoc();
  }

  runApp(MyApp(isLoggedIn));
}

class MyApp extends StatefulWidget {
  final LogInState isLoggedIn;
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
          body: widget.isLoggedIn == LogInState.LOGGED_IN ? Skeleton():widget.isLoggedIn == LogInState.LOGGED_OUT ? Welcome():NoConnectionView(),),
      ),
    );
  }
}

