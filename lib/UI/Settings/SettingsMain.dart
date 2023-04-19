import 'package:donde/BackendFunctions/ContactFunctions.dart';
import 'package:donde/BackendFunctions/Linking.dart';
import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/UI/IntroFlow/Welcome.dart';
import 'package:donde/UI/Settings/ContactView.dart';
import 'package:donde/UI/Settings/MyReviews.dart';
import 'package:donde/UI/Settings/SearchUserView.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsMain extends StatefulWidget {
  @override
  _SettingsMainState createState() => _SettingsMainState();
}

class _SettingsMainState extends State<SettingsMain> {



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20, left: 15, right:15, top:80),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,child: Text("Open Requests", style: UITemplates.settingsTextStyle,)),
                      style:  TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.transparent,
                      ),
                      onPressed: () {

                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => ContactView(ContactTypes.REQUESTS),
                          ),
                        );


                      },
                    ),
                    Divider(height: 1),
                    TextButton(
                      style:  TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.transparent,
                      ),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,child: Text("My Requests", style: UITemplates.settingsTextStyle,)),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => ContactView(ContactTypes.MY_REQUESTS),
                          ),
                        );
                      },
                    ),
                    Divider(height: 1),
                    TextButton(
                      style:  TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.transparent,
                      ),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,
                          child: Text("Friends", style: UITemplates.settingsTextStyle,)),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => ContactView(ContactTypes.FRIENDS),
                          ),
                        );
                      },
                    ),
                    Divider(height: 1),

                    TextButton(
                      style:  TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.transparent,
                      ),
                      child: Container(     alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,child: Text("MyReviews", style: UITemplates.settingsTextStyle,)),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyReviews(),
                          ),
                        );
                      },
                    ),
                    Divider(height: 1),

                    TextButton(
                      style:  TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.transparent,
                      ),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,
                          child: Text("Share my link", style: UITemplates.settingsTextStyle,)),
                      onPressed: () async{
                        String link = await Linking.createLinkToUser();
                        await Share.share(link);
                      },
                    ),

                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,

                margin: EdgeInsets.only(bottom: 20, left: 15, right:15, top:80),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Column(
                  children: [
                    TextButton(
                      style:  TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.transparent,
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text("Log Out", style: UITemplates.settingsTextdark,)),
                      onPressed: () async{
                        await SignUpFunctions.signOut();
                        Store.pers_controller?.dispose();
                        Navigator.of(context, rootNavigator: true).pushReplacement(
                          CupertinoPageRoute(
                            builder: (context) => Welcome(),
                          ),
                        );
                      },
                    ),
                    Divider(height: 1,),

                    TextButton(
                      style:  TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.transparent,
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text("Delete Account", style: UITemplates.settingsTextred,)),
                      onPressed: () async{
                        if(await SignUpFunctions.deleteUser()){
                          Store.pers_controller?.dispose();
                          Navigator.of(context, rootNavigator: true).pushReplacement(
                            CupertinoPageRoute(
                              builder: (context) => Welcome(),
                            ),
                          );
                        }else{
                          UITemplates.showErrorMessage(context, "Unable to delet Account. Please try again");
                        }
                      },
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style:  TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      foregroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                    return launchURL("https://www.dondeapp.de/privacy");
                  },
                    child: Text("Terms of Service", style: UITemplates.clickableText,),
                  ),
                  TextButton(style:  TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    foregroundColor: Colors.transparent,
                  ),
                    onPressed: () {
                    return launchURL("mailto:contact@dondeapp.de");
                  },
                    child: Text("Contact", style: UITemplates.clickableText,),

                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  static void launchURL(String s){
    launchUrl(Uri.parse(s));

  }
}
