import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/IntroFlow/LogIn.dart';
import 'package:donde/IntroFlow/SignUp.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
  Color borderColor = Colors.grey;
  late MyUser? referral;


  @override
  void initState() {
    super.initState();
    if(widget.referralUser != null){
      friendInput.text = widget.referralUser!.username;
    }
    referral = widget.referralUser;
    RelationshipFunctions.incrementSocialGraph(friendInput.text);

    FirebaseAnalytics.instance.logEvent(
      name: "Welcome view",
    );

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

            ],
          ),
          Positioned(
            bottom: 200,
            child: Container(
              width: MediaQuery.of(context).size.width*0.8,
              child: TextField(
                cursorColor: Colors.black,

                autofocus: true,
                controller: friendInput,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Enter your code here",
                  border: OutlineInputBorder(

                      borderSide: BorderSide(
                        width: 4,
                          color: borderColor,
                          style: BorderStyle.solid
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),

                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 4,
                          color: borderColor,
                          style: BorderStyle.solid
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
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
                    onPressed: ()async{
                      if (borderColor == Colors.green){
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => SignUp(friendInput.text),
                          ),
                        );
                      }else{
                        UITemplates.showErrorMessage(context, "Please provide a valid referral code to preceed");
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


  Future<String> checkInput(String input)async{
      MyUser? user = await RelationshipFunctions.getUserFromId(input);
      referral = user;
      if(user == null){
        setState(() {
          borderColor = Colors.red;
        });
      }else{
        setState(() {
          borderColor = Colors.green;
        });
      }
    return "";
  }
}
