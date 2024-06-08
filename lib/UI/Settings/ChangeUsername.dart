import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/Store.dart';
import 'package:donde/UI/IntroFlow/SignUp.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  TextEditingController usernameControl = TextEditingController(text: Store.me.username);
  TextEditingController uusernameControl = TextEditingController(text: Store.me.uniqueUsername);
  WaitingStates uniqueness = WaitingStates.UNIQUE;
  bool changed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UITemplates.appbar("Change username"),
      body: Column(
        children: [
          SizedBox(height: 40,),
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
                helperText: "Display name",

                hintStyle: UITemplates.importantTextStyleHint,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 30,),
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
                helperText: "Unique username",
                suffixIcon: uniqueness == WaitingStates.LOADING?Container(child: UITemplates.loadingAnimation, width: 30,):uniqueness==WaitingStates.UNIQUE?Icon(Icons.done):Icon(Icons.close),
                suffixIconColor:uniqueness==WaitingStates.UNIQUE?Colors.green:Colors.red,
                hintStyle: UITemplates.importantTextStyleHint,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*.1,),
          Container(
            width: MediaQuery.of(context).size.width*.7,
            height: 50,
            child: ElevatedButton(
              child: Text(changed ? "Changed!":"Change", style: UITemplates.buttonTextStyle,),
              style: ElevatedButton.styleFrom(
                backgroundColor: uniqueness == WaitingStates.UNIQUE?Colors.green:Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),),
              onPressed: ()async{
                if(uniqueness == WaitingStates.UNIQUE && (uusernameControl.text != Store.me.uniqueUsername||usernameControl.text != Store.me.username)){
                  await saveChanges();
                }else{
                  UITemplates.showErrorMessage(context, uniqueness == WaitingStates.UNIQUE? "Please change your name first":"Your username is taken already");
                }
              },
            ),
          ),
        ],
      ),
    );
  }



  Future<void> checkUniqueness()async{
    setState(() {
      changed = false;
    });
    if(uusernameControl.text == Store.me.uniqueUsername){
      setState(() {
        uniqueness = WaitingStates.UNIQUE;
      });
    }else{
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
  }


  Future<void> saveChanges()async{
    if(uusernameControl.text != Store.me.uniqueUsername||usernameControl.text != Store.me.username){
      bool success  = await SignUpFunctions.changeDetails(uusernameControl.text, usernameControl.text);
      setState(() {
        changed = success;
      });
    }
    await Store.initUser();
    setState(() {
      Store.me = Store.me;
    });

  }

}
