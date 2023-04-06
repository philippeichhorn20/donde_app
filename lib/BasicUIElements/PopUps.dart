import 'dart:ui';

import 'package:donde/Classes/Spot.dart';
import 'package:donde/MainViews/SpotView.dart';
import 'package:flutter/material.dart';

class PopUps{



  static Widget spotPopup(Spot spot){
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Padding(
        padding: const EdgeInsets.only(left:10.0,right: 10, top: 50,bottom: 40),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))

            ),
            child: SingleChildScrollView(child: SpotView(spot))),
      ),
    );
  }
}