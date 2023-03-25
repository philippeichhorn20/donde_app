import 'package:donde/IntroFlow/Welcome.dart';
import 'package:donde/MainViews/HomePage.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InviteFriends extends StatefulWidget {
  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: UITemplates.appbar("Invite friends"),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 60,
                child: Container(
                  width: MediaQuery.of(context).size.width*.7,
                  height: 50,
                  child: TextButton(
                    onPressed: (){
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: Text("Next",
                        style: UITemplates.buttonTextStyle),
                    style: UITemplates.buttonStyle,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
