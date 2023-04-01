import 'package:donde/BackendFunctions/Linking.dart';
import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/IntroFlow/Welcome.dart';
import 'package:donde/Settings/ContactView.dart';
import 'package:donde/Settings/SearchUserView.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';


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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100,),
            TextButton(
              child: Text("Followers", style: UITemplates.importantTextStyle,),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => ContactView(ContactTypes.FOLLOWER),
                  ),
                );
              },
            ),
            TextButton(
              child: Text("Following", style: UITemplates.importantTextStyle,),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => ContactView(ContactTypes.FOLLOWING),
                  ),
                );
              },
            ),
            TextButton(
              child: Text("Search", style: UITemplates.importantTextStyle,),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => SearchUserView(),
                  ),
                );
              },
            ),
            TextButton(
              child: Text("Copy invite link", style: UITemplates.importantTextStyle,),
              onPressed: () async{
                String uri = (await Linking.createLinkToUser()).toString();
                String text = "Hey, your frie";
                await Share.share(uri);
              },
            ),
            SizedBox(height: 100,),
            TextButton(
              child: Text("Log Out", style: UITemplates.importantTextStyleHint,),
              onPressed: () async{
                await SignUpFunctions.signOut();
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => Welcome(null),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
