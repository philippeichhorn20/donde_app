import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/IntroFlow/UserMatch.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUp extends StatefulWidget {

  final String contactName;
  const SignUp(this.contactName);

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
                    controller: numberControl,
                    style: UITemplates.importantTextStyle,

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
                  if(await signUpCorrect()){
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => UserMatch(widget.contactName),
                      ),
                    );
                  }
                },
              ),
            ),)
          ],
        ),
      ),
    );
  }


  Future<bool> signUpCorrect()async{
    User? user = await SignUpFunctions.signUp(numberControl.text, passwordControl.text, usernameControl.text);
    if(user== null){
      return false;
    }else{
      return true;
    }
  }
}
