import 'package:donde/Classes/MyUser.dart';
import 'package:donde/IntroFlow/LogIn.dart';
import 'package:donde/IntroFlow/SignUp.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  final MyUser? referralUser;
  const Welcome(this.referralUser, {super.key});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  TextEditingController friendInput = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.referralUser != null){
      friendInput.text = widget.referralUser!.id;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    "donde.",
                    style: UITemplates.titleStyle,

                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),

              Container(
                width: MediaQuery.of(context).size.width*0.5,
                child: TextField(
                  autofocus: true,
                controller: friendInput,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                hintText: "Enter your code here",
                  border: UITemplates.inputBorder,
                  focusedBorder: UITemplates.inputBorder,
                ),
              ),
              ),
            ],
          ),
          Positioned(
            bottom: 50,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*.7,
                  height: 50,
                  child: ElevatedButton(
                    child: Text("Enter",
                      style: UITemplates.buttonTextStyle,
                    ),
                    style: UITemplates.buttonStyle,
                    onPressed: (){
                      if (checkInput(friendInput.text)){
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => SignUp(friendInput.text),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Center(
                  child: TextButton(

                    child: Text("Just coming back", style: TextStyle(color: Colors.white30),),
                    onPressed: (){
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


  bool checkInput(String input){
    //check if
    return true;
  }
}
