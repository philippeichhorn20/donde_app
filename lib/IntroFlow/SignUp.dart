import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/IntroFlow/UserMatch.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUp extends StatefulWidget {
  final String refferal;
  const SignUp(this.refferal);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController numberControl = TextEditingController();
  TextEditingController usernameControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: 200,),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    cursorColor: Colors.black,

                    autofocus: true,
                    controller: usernameControl,
                    style: UITemplates.importantTextStyle,
                    decoration: InputDecoration(
                        hintText: "Username",
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

                    controller: numberControl,
                    style: UITemplates.importantTextStyle,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny("[a-zA-Z]"),
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
              child:
            Container(
              width: MediaQuery.of(context).size.width*.7,

              height: 50,
              child: ElevatedButton(
                child: Text("Sign Up", style: UITemplates.buttonTextStyle,),
                style: UITemplates.buttonStyle,
                onPressed: ()async{
                  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
                    print("Accepted permission: $accepted");
                  });
                  String s = await signUpCorrect();
                  if((s=="")){
                    OneSignal.shared.setExternalUserId(numberControl.text);

                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => UserMatch(),
                      ),
                    );
                  }else{
                    UITemplates.showErrorMessage(context, s);
                  }
                },
              ),
            ),),
            Positioned(top: 10, left: 0, child: UITemplates.goBackArrow(context)),

          ],
        ),
      ),
    );
  }


  Future<String> signUpCorrect()async {
    if(usernameControl.text == "" || passwordControl.text == ""){
      return "Enter your credentials";
    }
    try {
      User? user = await SignUpFunctions.signUp(
          numberControl.text, passwordControl.text, usernameControl.text, );
      await RelationshipFunctions.incrementSocialGraph(widget.refferal);
      return "";
    } on AuthException catch (e) {
      return e.message;
    }
    return "";
  }



}
