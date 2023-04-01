import 'package:flutter/material.dart';


class UITemplates{


  static TextStyle titleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 60,
  );


  static TextStyle smallTitleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 35,
  );

  static InputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
          color: Colors.white38,
        style: BorderStyle.solid
      ),
    borderRadius: BorderRadius.all(Radius.circular(50))
  );

  static InputBorder appBarInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
          color: Colors.transparent,
          style: BorderStyle.solid
      ),
      borderRadius: BorderRadius.all(Radius.circular(20))
  );

  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white38,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
  ),);

  static ButtonStyle lightButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white12,
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

  static Widget loadingAnimation = Center(
    child:  Container(height:30, width:30,child: CircularProgressIndicator(
      color: Colors.black,
    )),
  );

  //Spot Viex Templates

  static TextStyle nameStyle = TextStyle(color: Colors.white,fontWeight: FontWeight.w600, fontSize: 20);
  static TextStyle descriptionStyle = TextStyle(color: Colors.white54,fontWeight: FontWeight.w500, fontSize: 16);

  //foregroudn on reviews

static reviewText(double dark){
  return TextStyle(color: dark < 0.5 ? Colors.black :Colors.white,fontWeight: FontWeight.w700, fontSize: 25);
}
}