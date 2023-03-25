import 'package:flutter/material.dart';


class UITemplates{


  static TextStyle titleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 60,
  );

  static InputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
          color: Colors.white38,
        style: BorderStyle.solid
      ),
    borderRadius: BorderRadius.all(Radius.circular(50))
  );

  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white38,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
  ),);

  static TextStyle buttonTextStyle = const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700);


  static TextStyle importantTextStyleHint = const TextStyle(color: Colors.white38, fontSize: 30, fontWeight: FontWeight.w500);
  static TextStyle importantTextStyle = const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700);


  static AppBar appbar(String text){
    return AppBar(
      title: Text(text),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }


  //Spot Viex Templates

  static TextStyle nameStyle = TextStyle(color: Colors.white,fontWeight: FontWeight.w600, fontSize: 25);
  static TextStyle descriptionStyle = TextStyle(color: Colors.white54,fontWeight: FontWeight.w500, fontSize: 20);
}