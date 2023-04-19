import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/UI/IntroFlow/LocationPermissionView.dart';
import 'package:donde/UI/MainViews/HomePage.dart';
import 'package:donde/UI/MainViews/Skeleton.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController numberControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    cursorColor: Colors.black,

                    autofocus: true,
                    controller: numberControl,
                    style: UITemplates.importantTextStyle,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny("[a-zA-Z]")
                    ],
                    decoration: InputDecoration(
                      hintText: "Phone number",
                      hintStyle: UITemplates.importantTextStyleHint,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    cursorColor: Colors.black,

                    controller: passwordControl,
                    style: UITemplates.importantTextStyle,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: UITemplates.importantTextStyleHint,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 60,
              child: Container(
                width: MediaQuery.of(context).size.width * .7,
                height: 50,
                child: ElevatedButton(
                  child: Text(
                    "Log In",
                    style: UITemplates.buttonTextStyle,
                  ),
                  style: UITemplates.buttonStyle,
                  onPressed: () async {
                    OneSignal.shared
                        .promptUserForPushNotificationPermission()
                        .then((accepted) {
                    });


                    String s = await logInCorrect();
                    if (s == "") {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (context) => LocationPermissionView(),
                        ),
                      );
                    } else {
                      UITemplates.showErrorMessage(context, s);
                    }
                  },
                ),
              ),
            ),
            Positioned(
                top: 10, left: 0, child: UITemplates.goBackArrow(context)),
          ],
        ),
      ),
    );
  }

  Future<String> logInCorrect() async {
    if (passwordControl.text == "" ||
        passwordControl.text == "" ||
        numberControl.text == "") {
      return "Enter your credentials";
    }
    return (await SignUpFunctions.logIn(
            numberControl.text, passwordControl.text))
        ? ""
        : "No matching user found";
  }
}
