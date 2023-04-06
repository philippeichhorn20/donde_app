import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/BasicUIElements/ListTiles.dart';
import 'package:donde/BasicUIElements/PopUps.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Linking{



  static Future<Uri> createLinkToUser()async{
    Uri link = await DynamicLinkParameters(
      uriPrefix:"https://opendonde.page.link",
      link: Uri.parse("https://opendonde.page.link/?user=${Store.me.id}"),
      androidParameters:  AndroidParameters(packageName: "com.donde.app.android"),
      googleAnalyticsParameters:
      GoogleAnalyticsParameters(source: "gh", medium: "hi", campaign: "h"),
      iosParameters:  IOSParameters(bundleId: "com.donde.app.ios", appStoreId: "6447265098",
          customScheme:"?user=${Store.me.id}" ),
      socialMetaTagParameters: SocialMetaTagParameters(
      ),
      navigationInfoParameters: NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
    ).link;
    return link;
  }

  static Future<Uri> createLinkToSpot(Spot spot)async{
    Uri link = await DynamicLinkParameters(
      uriPrefix:"https://opendonde.page.link",
      link: Uri.parse("https://opendonde.page.link/?user=${Store.me.id}&spot=${spot.id}"),
      androidParameters:  AndroidParameters(packageName: "com.donde.app.android"),
      googleAnalyticsParameters:
      GoogleAnalyticsParameters(source: "gh", medium: "hi", campaign: "h"),
      iosParameters:  IOSParameters(bundleId: "com.donde.app.ios", appStoreId: "6447265098",
      customScheme:"?user=${Store.me.id}" ),
      socialMetaTagParameters: SocialMetaTagParameters(
      ),
      navigationInfoParameters: NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
    ).link;
    return link;
  }

  static Future<MyUser?> retrieveUser(Uri uri)async{
    String? res = uri.queryParameters["user"];
    if(res != null){
      print("item found");
      return await RelationshipFunctions.getUserFromId(res);
    }
    return null;
  }

  static Future<Spot?> retrieveSpot(Uri uri)async{
    String? res = uri.queryParameters["spot"];
    if(res != null){
      return await SpotFunctions.getspotfromid(res);
    }
    return null;
  }

  static Future<void> handlePotentialLinks(GlobalKey key)async{
    print("link detector innit");


    FirebaseDynamicLinks.instance.onLink.listen( (linkData)async {
      print(linkData.link.queryParameters.toString());

      Spot? spot = await retrieveSpot(linkData.link);
      MyUser? user = await retrieveUser(linkData.link);
      print("items retrieved");

      if(user!= null){
        if(key.currentContext != null){
          ListTiles.showSnackbar( key.currentContext!, user,key.currentState!.setState);
        }
      }
      if(spot!=null){
        print("spot found");
        if(key.currentContext != null){
          showDialog(context: key.currentContext!, builder: (context) {
            return PopUps.spotPopup(spot);
          },);
        }
      }

    },

     onError: (error) async{
      print(error.stacktrace);

      print(error.details);
      print("error");
    },
    );
  }

}