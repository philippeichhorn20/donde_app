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

  static ButtonStyle mapButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
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

static showErrorMessage(BuildContext context, String str){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: EdgeInsets.only(bottom: 100, left: 10,right: 10),
      padding: EdgeInsets.only(left:10,right: 10, bottom: 10),
      behavior: SnackBarBehavior.floating,

      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.all(Radius.circular(20))

  ),

      content: Container(
        height: 60,
        child: Center(
          child: Text(
            str,
            style: UITemplates.buttonTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    )
  );
}

static Widget goBackArrow(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 40.0, left: 25, bottom: 20),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white12,
        ),
        child: TextButton(

          child: Icon(Icons.close, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}
}