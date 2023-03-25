import 'package:donde/Settings/ContactView.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SettingsMain extends StatefulWidget {
  @override
  _SettingsMainState createState() => _SettingsMainState();
}

class _SettingsMainState extends State<SettingsMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Column(
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
              child: Text("Proposals", style: UITemplates.importantTextStyle,),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => ContactView(ContactTypes.PROPOSALS),
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
