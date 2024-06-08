import 'package:donde/Classes/Review.dart';
import 'package:donde/UI/MainViews/ReactionView.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/material.dart';

class SpecialUIElements{




  static Widget feedbackIndicator(Review review){


    return StatefulBuilder(builder: (context, setState) {
      return LayoutBuilder(
        builder: (context, snapshot) {
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Row(
                children: [
                 FittedBox(
                   fit: BoxFit.scaleDown,
                   child: TextButton(
                       style: TextButton.styleFrom(
                           padding: EdgeInsets.zero
                       ),
                       onPressed: (){
                         setState((){
                           review.iChangeMind(Reactions.HEART);
                         });

                       },
onLongPress: () {
  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReactionView(review: review, index: 0,)));
},
                       child: Chip(label: Text("❤️", style: TextStyle(fontSize: 17),), avatar: Text(review.heartCount.toString(), style: UITemplates.numberOnReactionStyle,),
                       padding: EdgeInsets.zero,
                         backgroundColor: Colors.white12,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                           side: BorderSide(
                             width: 2,
                             color: review.iHeart? Colors.green: Colors.transparent
                           )
                         ),
                       )

                   ),
                 ),
                  SizedBox(width: 6,),
                  FittedBox(
                    fit: BoxFit.scaleDown,

                    child: TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero
                        ),
                        onPressed: (){
                          setState((){
                            review.iChangeMind(Reactions.BEEN);
                          });
                        },
                        onLongPress: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ReactionView(review: review, index: 1,)));
                        },
                        child: Chip(label: Text("Been there!",), avatar: Text(review.beenCount.toString(), style: UITemplates.numberOnReactionStyle),
                          backgroundColor: Colors.white12,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  width: 2,
                                  color: review.iveBeen? Colors.green: Colors.transparent
                              )
                          ),                )),
                  ),
                  SizedBox(width: 6,),

                  FittedBox(
                    fit: BoxFit.scaleDown,

                    child: TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap
                        ),
                        onPressed: (){
                          setState((){
                            review.iChangeMind(Reactions.LOVE);
                          });
                        },
                        onLongPress: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ReactionView(review: review, index: 2,)));
                        },
                        child: Chip(label: Text("Loved it!",), avatar: Text(review.loveCount.toString(),  style: UITemplates.numberOnReactionStyle),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white12,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  width: 2,
                                  color: review.iLoveIt? Colors.green: Colors.transparent
                              )
                          ),
                        )),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,

                    child: TextButton(
                        style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero
                        ),
                        onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReactionView(review: review, index: 0,)));
                    }, child: Icon(Icons.list, color: Colors.white,)),
                  )
                ],
              ),
            ),
          );
        }
      );
    },);
  }


}