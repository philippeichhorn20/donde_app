import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/UI/IntroFlow/ContactShareView.dart';
import 'package:donde/UI/IntroFlow/UserMatch.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class SignUp extends StatefulWidget {
  final String refferal;
  const SignUp(this.refferal);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController numberControl = TextEditingController(text: "+49");
  TextEditingController usernameControl = TextEditingController();
  TextEditingController uusernameControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();
  WaitingStates uniqueness = WaitingStates.NOT_UNIQUE;
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
                SizedBox(height: 100,),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    cursorColor: Colors.black,

                    autofocus: true,
                    controller: usernameControl,
                    style: UITemplates.importantTextStyle,
                    maxLength: 20,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                        hintText: "Name",
                      hintStyle: UITemplates.importantTextStyleHint,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  //uniqueUsername
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    cursorColor: Colors.black,
                    autofocus: true,
                    controller: uusernameControl,
                    style: UITemplates.importantTextStyle,
                    onChanged: (value) {
                      checkUniqueness();
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                      RegExp(r'\s')),
                    ],
                    decoration: InputDecoration(

                      hintText: "Username",
                      suffixIcon: uniqueness == WaitingStates.LOADING?Container(child: UITemplates.loadingAnimation, width: 30,):uniqueness==WaitingStates.UNIQUE?Icon(Icons.done):Icon(Icons.close),
                      suffixIconColor:uniqueness==WaitingStates.UNIQUE?Colors.green:Colors.red,
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
                  });
                  String s = await signUpCorrect();
                  if((s=="")){

                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => ContactShareView(isOutsideIntroFlow: false),
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

  Future<void> checkUniqueness()async{
    setState(() {
      uniqueness = WaitingStates.LOADING;
    });
    bool uniquenessBool;
    if(uusernameControl.text.length > 0){
       uniquenessBool = await SignUpFunctions.checkUniqueness(uusernameControl.text);
    }else{
      uniquenessBool = false;
    }
    setState(() {
      if(uniquenessBool){
        uniqueness = WaitingStates.UNIQUE;
      }else{
        uniqueness = WaitingStates.NOT_UNIQUE;

      }
    });
  }

  Future<String> signUpCorrect()async {
    if(usernameControl.text == "" ||uusernameControl.text == "" || passwordControl.text == ""||numberControl.text == ""){
      return "Enter your credentials";
    }
    if(uniqueness != WaitingStates.UNIQUE){
      return "Your username is not unique";
    }
    if(numberControl.text.characters.first != "+"){
      return "Add country code (+49 in Germany) to your phone number";
    }
    try {
      User? user = await SignUpFunctions.signUp(
          numberControl.text, passwordControl.text, usernameControl.text, uusernameControl.text);
      await RelationshipFunctions.incrementSocialGraph(widget.refferal);
      return "";
    } on AuthException catch (e) {
      return e.message;
    }
  }
}


enum WaitingStates{
  UNIQUE,NOT_UNIQUE,LOADING
}
