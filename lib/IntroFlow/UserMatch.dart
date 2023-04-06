import 'package:donde/BackendFunctions/GetFriends.dart';
import 'package:donde/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/IntroFlow/InviteFriends.dart';
import 'package:donde/UITemplates.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:supabase_flutter/supabase_flutter.dart';

class UserMatch extends StatefulWidget {




  @override
  _UserMatchState createState() => _UserMatchState();
}

class _UserMatchState extends State<UserMatch> {
  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UITemplates.appbar("Add your friends"),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: FutureBuilder(
                future: getFriends(""),
                builder: (context, snapshot){
                  if(snapshot == null || snapshot.data == null || snapshot.data!.length ==0){
                    return SizedBox(height: 10, width: 10,);
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height*.8,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: snapshot == null||snapshot.data == null?0:snapshot.data!.length,
                      itemBuilder: (context, index) {
                        MyUser user = snapshot.data![index];
                        return ListTiles.userListTile(user, context);
                      },),
                  );
                }),
          ),
          Positioned(
              bottom: 50,
              child: Container(
                width: MediaQuery.of(context).size.width*.7,
                height: 50,
                child: TextButton(
                  onPressed: (){
                    FirebaseAnalytics.instance.logEvent(name: "exit_user_match");

                    Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(
                        builder: (context) => InviteFriends(),
                      ),
                    );
                  },
                  child: Text("Next",
                      style: UITemplates.buttonTextStyle),
                  style: UITemplates.buttonStyle,
                ),
              )),
        ],
      )
    );
  }

  Future<List<MyUser>> getFriends(String contactName)async{
    FirebaseAnalytics.instance.logEvent(name: "user_match");
      return GetFriends.getFriendsFromContact(contactName);

  }
}
