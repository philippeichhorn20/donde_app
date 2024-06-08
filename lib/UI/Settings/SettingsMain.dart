import 'package:donde/BackendFunctions/ContactFunctions.dart';
import 'package:donde/BackendFunctions/Linking.dart';
import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/UI/IntroFlow/ContactShareView.dart';
import 'package:donde/UI/IntroFlow/Welcome.dart';
import 'package:donde/UI/Settings/ChangeUsername.dart';
import 'package:donde/UI/Settings/ContactView.dart';
import 'package:donde/UI/Settings/DeletePage.dart';
import 'package:donde/UI/Settings/ImprintPage.dart';
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

                    Divider(height: 1),

                    TextButton(
                      style:  TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.transparent,
                      ),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,
                          child: Text("Change username", style: UITemplates.settingsTextStyle,)),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const ChangeUsername(),
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),Container(
                margin: EdgeInsets.only(bottom: 20, left: 15, right:15, top:10),
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
                          width: MediaQuery.of(context).size.width,child: Text("Contact check", style: UITemplates.settingsTextStyle,)),
                      style:  TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.transparent,
                      ),
                      onPressed: () {

                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => ContactShareView(isOutsideIntroFlow: true),
                          ),
                        );


                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,

                margin: EdgeInsets.only(bottom: 20, left: 15, right:15, top:10),
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
                        showCupertinoModalPopup(context: context, builder: (context) {
                          return CupertinoAlertDialog(
                            content: Text("Are your sure you want to log out?"),
                            title: Text("Log Out"),
                            actions: [

                              CupertinoDialogAction(
                                onPressed: () async{
                                  Navigator.pop(context);
                                  await SignUpFunctions.signOut();
                                  Store.pers_controller?.dispose();
                                  Navigator.of(context, rootNavigator: true).pushReplacement(
                                    CupertinoPageRoute(
                                      builder: (context) => Welcome(),
                                    ),
                                  );
                                },
                                child: const Text('Log Out'),
                              ),
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'),
                              ),
                            ],
                          );
                        },);
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
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(
                            builder: (context) => DeletePage(),
                          ),
                        );

                      },
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    style:  TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      foregroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                    return launchURL("https://www.dondeapp.de/terms");
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
                    child: Text("Tell us what you think!", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700, fontSize: 15),),

                  )
                ],
              ),
              Center(child:
              TextButton(
                style:  TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  foregroundColor: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                      builder: (context) => ImPrintPage(),
                    ),
                  );
                },
                child: Text("Imprint", style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white24
                ),),
              ),)
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
