import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Store.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class Linking{



  static Future<Uri> createLinkToUser()async{
    Uri link = await DynamicLinkParameters(
      uriPrefix:"https://flutterdevs.page.link",
        link: Uri.parse("https://opendonde.page.link"),
      androidParameters:  AndroidParameters(packageName: "com.example.app.android"),
        googleAnalyticsParameters:
        GoogleAnalyticsParameters(source: "", medium: "", campaign: ""),
      iosParameters:  IosParameters(bundleId: "com.example.app.ios"),
      socialMetaTagParameters: SocialMetaTagParameters(

      )
    ).buildUrl(

    );
    return link;
  }

  static Future<MyUser?> retrieveUser(Uri uri)async{
    String? res = uri.queryParameters["uid"];
    if(res != null){
      return await RelationshipFunctions.getUserFromId(res);
    }
    return null;
  }

}