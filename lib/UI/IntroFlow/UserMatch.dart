import 'package:donde/BackendFunctions/GetFriends.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/UI/IntroFlow/InviteFriends.dart';
import 'package:donde/UI/IntroFlow/LocationPermissionView.dart';
import 'package:donde/UI/MainViews/Skeleton.dart';
import 'package:donde/UITemplates.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserMatch extends StatefulWidget {
  @override
  _UserMatchState createState() => _UserMatchState();
}

class _UserMatchState extends State<UserMatch> {
  bool isSearched = false;
  List<MyUser> users = [];
  GlobalKey<AnimatedListState> animListKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFriends("");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: UITemplates.appbar("Add your friends"),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 0,
                child: Column(
                  children: [
                    if (users.isEmpty)
                      const SizedBox(
                        height: 10,
                        width: 10,
                      ),
                    if (users.isNotEmpty)
                      Container(
                        height: MediaQuery.of(context).size.height * .8,
                        width: MediaQuery.of(context).size.width,
                        child: AnimatedList(
                          key: animListKey,
                          initialItemCount: users.length,
                          itemBuilder: (context, index, animation) {
                            MyUser user = users[index];
                            return ListTiles.userListTile(user, context, action: action);
                          },
                        ),
                      ),
                  ],
                )),
            Positioned(
                bottom: 50,
                child: Container(
                  width: MediaQuery.of(context).size.width * .7,
                  height: 50,
                  child: TextButton(

                    onPressed: () {
                      FirebaseAnalytics.instance
                          .logEvent(name: "exit_user_match");
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (context) => LocationPermissionView(),
                        ),
                      );
                      //Todo nach invite friends
                    },
                    child: Text("Next", style: UITemplates.buttonTextStyle),
                    style: UITemplates.buttonStyle,
                  ),
                )),
          ],
        ));
  }

  Future<void> getFriends(String contactName) async {
    FirebaseAnalytics.instance.logEvent(name: "user_match");
    users = await GetFriends.getFriendsFromContact(contactName);
    setState(() {
      users = users;
    });
  }

  Future<void> action()async{
    List<MyUser> newUsers = await GetFriends.getFriendsFromContact("");
    newUsers.removeWhere((element) => users.contains(element as MyUser));
    int histLength = users.length;
    users.addAll(newUsers);
    animListKey.currentState?.insertAllItems(histLength, newUsers.length);
  }


}
