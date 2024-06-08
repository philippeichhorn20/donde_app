import 'dart:ui';

import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
import 'package:donde/UI/BasicUIElements/PopUps.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/UI/MainViews/SpotView.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';

class Linking{


  static MyUser? possibleReferral;
  static DateTime? lastLinkUpdate;

  static Future<String> createLinkToUser()async{
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://opendonde.page.link/hey?user=${Store.me.id}"),
      uriPrefix: "https://opendonde.page.link",
      androidParameters: const AndroidParameters(packageName: "com.example.app.android"),
      iosParameters: const IOSParameters(bundleId: "com.example.app.ios"),
      navigationInfoParameters: NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
    );
    final dynamicLink =
    await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    return dynamicLink.shortUrl.toString();
  }

  static Future<String> createLinkToSpot(Spot spot)async{
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://opendonde.page.link/hey?user=${Store.me.id}&spot=${spot.id}"),
      uriPrefix: "https://opendonde.page.link",
      androidParameters: const AndroidParameters(packageName: "com.example.app.android"),
      iosParameters: const IOSParameters(bundleId: "com.example.app.ios"),
        navigationInfoParameters: NavigationInfoParameters(
          forcedRedirectEnabled: true,
        ),
    );
    final dynamicLink =
    await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    return dynamicLink.shortUrl.toString();
  }

  static Future<MyUser?> handlePotentialInitLinks()async{
    PendingDynamicLinkData? pendingData = await FirebaseDynamicLinks.instance.getInitialLink();
    if(pendingData== null){
      return null;
    }
    MyUser? user;
    if(pendingData.link.queryParameters["user"] != null) {
      user = await RelationshipFunctions.getUserFromId(
          pendingData.link.queryParameters["user"]!);
    }
    return user;
  }


  static Future<void> handlePotentialLinks(GlobalKey snackbarKey)async{
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData data) async{
      MyUser? user;



      if(data.link.queryParameters["user"] != null) {
         user = await RelationshipFunctions.getUserFromId(
            data.link.queryParameters["user"]!);
         possibleReferral = user;
      }
      Spot? spot;
      if(data.link.queryParameters["spot"] != null) {
        spot = await SpotFunctions.getspotfromid(data.link.queryParameters["spot"]!);
      }
        if(user != null){
          if(snackbarKey.currentContext != null){
            ScaffoldMessenger.of(snackbarKey.currentContext!).showSnackBar(
                ListTiles.showSnackbar(user)
            );
          }
        }
        if(spot != null){
          showDialog(context: snackbarKey.currentContext!, builder: (context) {
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
                    child: SingleChildScrollView(child: SpotView(spot!, (){}))),
              ),
            );
          },);
        }

      if(data.link.queryParameters["spot"] != null){
        Spot? spot = await SpotFunctions.getspotfromid(data.link.queryParameters["spot"]!);
      }
    });
  }

}