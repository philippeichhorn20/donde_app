import 'dart:typed_data';
import 'dart:ui';

import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/UI/MainViews/SpotView.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopUps {


  static Widget spotPopup(Spot spot) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 10, top: 50, bottom: 40),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))

            ),
            child: SingleChildScrollView(child: SpotView(spot, (){}))),
      ),
    );
  }


  static SnackBar reportSnackbar(BuildContext context, Review review) {
    int isSuccess = 0; // O: wait, 1:loading,2:success

    return SnackBar(
      margin: EdgeInsets.only(left:5,right: 5, bottom:70),
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          1)!,
      content: StatefulBuilder(
          builder: (context, setState) {
            return isSuccess ==0?Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Want to report this post?",style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ), textAlign: TextAlign.start),
                  Text("Thank you for helping us identifying harmful content!",style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                  ), textAlign: TextAlign.start),
                  TextButton(
                    style:  TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      foregroundColor: Colors.transparent,
                    ),
                    onPressed: () async{
                    setState(() {
                      isSuccess = 1;
                    });
                    await ReviewFunctions.reportReview(review, "");
                    setState(() {
                      isSuccess = 2;
                    });
                    await Future.delayed(Duration(seconds: 2));
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }, child: Container(
                      alignment: Alignment.centerRight,
                      child: Text("Submit", style: UITemplates.buttonTextStyle,)),)
                ],
              ),
            ):isSuccess == 1?UITemplates.loadingAnimation:Icon(Icons.check_circle, color: Colors.green, size: 50);
          }
      ),

      backgroundColor: Colors.grey[600],
      duration: Duration(days: 1),
    );
  }





}