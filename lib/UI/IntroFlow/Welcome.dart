import 'package:donde/BackendFunctions/Linking.dart';
import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/UI/IntroFlow/LogIn.dart';
import 'package:donde/UI/IntroFlow/SignUp.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  TextEditingController friendInput =
      TextEditingController(text: Linking.possibleReferral?.id);
  Color borderColor = Colors.grey;
  late MyUser? referral;
  MyUser? referralUser;

  @override
  void initState() {
    super.initState();
    RelationshipFunctions.incrementSocialGraph(friendInput.text);
    FirebaseAnalytics.instance.logEvent(
      name: "Welcome_view",
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      print("new");
      initLinkSearch();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Image.asset('assets/donde.png', width: MediaQuery.of(context).size.width*.7, ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height*.4,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                cursorColor: Colors.black,
                autofocus: true,
                controller: friendInput,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Paste invite code or open with link",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 4,
                          color: borderColor,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 4,
                          color: borderColor,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onChanged: ((value) {
                  checkInput(value);
                  setState(() {
                    borderColor = Colors.orange;
                  });
                }),
              ),
            ),
          ),
          TextButton(
              style:  TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                foregroundColor: Colors.transparent,
              ),
              onPressed: (){
            friendInput.text = "05d35495-26fc-4077-b2ae-36c8c73252e5";
            checkInput(friendInput.text);
          }, child: Text("Test", style: TextStyle(color: Colors.transparent),)),
          Positioned(
            top: MediaQuery.of(context).size.height*.75,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .7,
                  child: TextButton(
                    style:  TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      foregroundColor: Colors.transparent,
                    ),
                    child: Text(
                      "By signing up, you agree to our Terms of Service and Privacy Policy",
                      style: TextStyle(color: Colors.white60,fontWeight : FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      launchUrl(Uri.parse("https://dondeapp.de/terms"));
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .7,
                  height: 50,
                  child: ElevatedButton(
                    child: Text(
                      "Enter",
                      style: UITemplates.buttonTextStyle,
                    ),
                    style: UITemplates.buttonStyle,
                    onPressed: () async {
                      if (borderColor == Colors.green || true) {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => SignUp(friendInput.text),
                          ),
                        );
                        HapticFeedback.heavyImpact();
                      } else {
                        UITemplates.showErrorMessage(context,
                            "Please provide a valid referral code to proceed");
                      }
                    },
                  ),
                ),
                Center(
                  child: TextButton(
                    style:  TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      foregroundColor: Colors.transparent,
                    ),
                    child: Text(
                      "Just coming back",
                      style: TextStyle(color: Colors.white30),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => LogIn(),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<String> checkInput(String input) async {
    MyUser? user = await RelationshipFunctions.getUserFromId(input);
    referral = user;
    if (user == null) {
      setState(() {
        borderColor = Colors.red;
      });
    } else {
      setState(() {
        borderColor = Colors.green;
      });
    }
    return "";
  }

  Future<void> initLinkSearch() async {
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData data) async{
      final Uri? deepLink = data?.link;
      if (deepLink != null) {
        print("deep link");
        print(deepLink);
        String? id = deepLink.queryParameters['user'];
        if (id != null) {
          friendInput.text = id;
          checkInput(friendInput.text);
        }
      }

    }
    );
  }
}
