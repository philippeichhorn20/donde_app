import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class UITemplates{


  static TextStyle titleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 60,
  );


  static TextStyle smallTitleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 45,
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
      borderRadius: BorderRadius.all(Radius.circular(15))
  );

  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white38,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
  ),);

  static TextStyle numberOnReactionStyle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w700
  );

  static ButtonStyle lightButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.grey[800],
elevation: 0,
    shadowColor: Colors.transparent,
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
    );
  }

  static Widget loadingAnimation = Center(
    child:  Container(height:30, width:30,child: CircularProgressIndicator(
      color: Colors.black,
    )),
  );

  //Spot Viex Templates

  static TextStyle nameStyle = TextStyle(color: Colors.white,fontWeight: FontWeight.w600, fontSize: 24);
  static TextStyle descriptionStyle = TextStyle(color: Colors.white54,fontWeight: FontWeight.w500, fontSize: 14);
  static TextStyle clickableText = TextStyle(color: Colors.white70,fontWeight: FontWeight.w500, fontSize: 16);
  static TextStyle clickableTextButBold = TextStyle(color: Colors.white70,fontWeight: FontWeight.w800, fontSize: 16);
  static TextStyle reviewNoteStyle = TextStyle(color: Colors.white70,fontWeight: FontWeight.w600, fontSize: 14);
  static TextStyle settingsTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18,);
  static TextStyle settingsTextdark = TextStyle(color: Colors.white54, fontWeight: FontWeight.w600, fontSize: 18,);
  static TextStyle settingsTextred = TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 18,);
  static TextStyle reviewExperienceStyle =  TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600);

  //foregroudn on reviews

static reviewText(double dark){
  return TextStyle(color: dark < 0.5 ? Colors.black :Colors.white,fontWeight: FontWeight.w700, fontSize: 25);
}

static showErrorMessage(BuildContext context, String str){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: EdgeInsets.only(bottom: 80, left: 10,right: 10),
      padding: EdgeInsets.only(left:10,right: 10, bottom: 10),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.all(Radius.circular(20))

  ),

      content: Container(
        padding: EdgeInsets.only(top: 30, bottom: 30),
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
          style:  TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            foregroundColor: Colors.transparent,
          ),
          child: Icon(Icons.close, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

static RatingWidget ratingBarItem = RatingWidget(
    empty: Icon(
      Icons.circle_outlined,
      color: Colors.grey,
    ),
    full: Icon(Icons.circle_rounded, color: Colors.black,),
    half: SizedBox());



static Widget relationShipIndicator(MyUser user, bool minimal){
  String relTypeStr = MyUser.relTypeToButtonString(user.relationshipType);
  Color friendshipColor = user.relationshipType == RelationshipTypes.REQUESTED_BY_OTHER ? Colors.green : Colors.grey;
  return StatefulBuilder(builder: (context, setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if(user.relationshipType != RelationshipTypes.ME && user.relationshipType != RelationshipTypes.BLOCKED && !minimal)
          TextButton.icon(
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap
              ),
              onPressed: ()async {
             await RelationshipFunctions.blockUser(user, true);
            setState((){
              user.relationshipType = user.relationshipType;
              relTypeStr = MyUser.relTypeToButtonString(user.relationshipType);
            });
          }, icon: Icon(Icons.block, color: Colors.white24,), label: SizedBox()),
        if(user.relationshipType == RelationshipTypes.REQUESTED_BY_OTHER)
          TextButton(
            onPressed: () async{
              await RelationshipFunctions.declineFriendship(user, true);
              setState((){
                user.relationshipType = user.relationshipType;
                friendshipColor = user.relationshipType == RelationshipTypes.REQUESTED_BY_OTHER ? Colors.green : Colors.grey;
                relTypeStr = MyUser.relTypeToButtonString(user.relationshipType);
              });
            },
            style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.only(top:3, bottom: 3,left: 5, right: 5),
              minimumSize: Size.zero,
                splashFactory: NoSplash.splashFactory,
                foregroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),),
            //TODO
            child: Text(("decline"),
              style: TextStyle(
                  color: Colors.white38,
                  fontWeight: FontWeight.w500,
                  fontSize: 15
              ),),
          ),

        if(user.relationshipType != RelationshipTypes.BLOCKED)
        ElevatedButton(
          onPressed: () async{
            await RelationshipFunctions.handleFriendshipActions(user);
            setState((){
              user.relationshipType = user.relationshipType;
              friendshipColor = user.relationshipType == RelationshipTypes.REQUESTED_BY_OTHER ? Colors.green : Colors.grey;
              relTypeStr = MyUser.relTypeToButtonString(user.relationshipType);
            });
          },
          style: ElevatedButton.styleFrom(

            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.only(top:3, bottom: 3,left: 5, right: 5),
            minimumSize: Size.zero,
            backgroundColor: friendshipColor,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),),
          //TODO
          child: Text((relTypeStr),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14
            ),

          ),

        ),
      ],
    );
  },);
}
}