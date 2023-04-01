import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/MainViews/HomePage.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: 200,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
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
                  child: Text("Log In", style: UITemplates.buttonTextStyle,),
                  style: UITemplates.buttonStyle,
                  onPressed: ()async{
                    if(await logInCorrect()){
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => HomePage(),
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
  Future<bool> logInCorrect()async{
    return await SignUpFunctions.logIn(numberControl.text, passwordControl.text);
  }
}
