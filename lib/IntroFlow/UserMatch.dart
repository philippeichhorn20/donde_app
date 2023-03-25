import 'package:donde/BackendFunctions/GetFriends.dart';
import 'package:donde/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/IntroFlow/InviteFriends.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:supabase_flutter/supabase_flutter.dart';

class UserMatch extends StatefulWidget {

  final String contactName;
  const UserMatch(this.contactName);



  @override
  _UserMatchState createState() => _UserMatchState();
}

class _UserMatchState extends State<UserMatch> {
  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: UITemplates.appbar("Add your friends"),
        body: Stack(
          alignment: Alignment.center,
          children: [
            FutureBuilder(
                future: getFriends(widget.contactName),
                builder: (context, snapshot){
                  if(snapshot == null || snapshot.data == null || snapshot.data!.length ==0){
                    return SizedBox();
                  }
                  return ListView.builder(
                    itemCount: snapshot == null||snapshot.data == null?0:snapshot.data!.length,
                    itemBuilder: (context, index) {
                      MyUser user = snapshot.data![index];
                      return ListTiles.userListTile(user, context);
                    },);
                }),
            Positioned(

                bottom:60,
                child: Container(
                  width: MediaQuery.of(context).size.width*.7,
                  height: 50,
                  child: TextButton(
                    onPressed: (){
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => InviteFriends(),
                        ),
                      );
                    },
                    child: Text("Next",
                        style: UITemplates.buttonTextStyle),
                    style: UITemplates.buttonStyle,
                  ),
                ))
          ],
        )
      ),
    );
  }

  Future<List<MyUser>> getFriends(String contactName)async{
      return GetFriends.getFriendsFromContact(contactName);
  }
}
