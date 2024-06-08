import 'package:donde/BackendFunctions/GetFriends.dart';
import 'package:donde/BackendFunctions/Linking.dart';
import 'package:donde/Store.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/UI/Settings/SettingsMain.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class SearchUserView extends StatefulWidget {
  @override
  _SearchUserViewState createState() => _SearchUserViewState();
}

class _SearchUserViewState extends State<SearchUserView> {
  TextEditingController searchText = TextEditingController();
  List<MyUser> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callFunction();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
     // color: Colors.grey[850],
      child: Column(
        children: [
          SizedBox(height: 60,),
          Row(
            children: [
              Expanded(child: SizedBox()),
              Container(
                width:MediaQuery.of(context).size.width*.75,
                child: TextField(
                  controller: searchText,
                  cursorColor: Colors.black,
                  style: UITemplates.settingsTextStyle,
                  autofocus: true,
                  decoration: InputDecoration(

                    fillColor: Colors.grey[700],
                    hintText: "Find users",
                    hintStyle: UITemplates.settingsTextStyle,
                    focusedBorder: UITemplates.appBarInputBorder,
                    filled: true,
                    border: UITemplates.appBarInputBorder,
                    enabledBorder: UITemplates.appBarInputBorder,
                  ),
                  onSubmitted: (value) {
                    callFunction();
                  },
                  onChanged: (text){
                    if(text.length%2==0){
                      callFunction();
                    }
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => SettingsMain(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: Icon(Icons.settings, size: 28,))
            ],
          ),

          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.green[700],

                borderRadius: BorderRadius.all(Radius.circular(10))
            ),

            width: MediaQuery.of(context).size.width,
            child: ListTile(

              onTap: ()async{
                String link = await Linking.createLinkToUser();
                await Share.share(link);
              },

              leading: Icon(Icons.ios_share, size: 30,),
              title: Text("Invite friends", style: UITemplates.settingsTextStyle,),
              subtitle: Text(Store.me.uniqueUsername??Store.me.username, style: UITemplates.reviewNoteStyle,),
            ),

          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left:12.0, top: 5,bottom: 5) ,
              child: Text(searchText.text.isEmpty?"Our recommendations":"Your search results", style: UITemplates.descriptionStyle,textAlign: TextAlign.start,),
            ),
          ),
          Flexible(
            child: RefreshIndicator(
              onRefresh: callFunction,
              color: Colors.black,
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 60),
                scrollDirection: Axis.vertical,
                shrinkWrap: false,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  MyUser user = users[index];
                  return ListTiles.userListTile(user, context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }


   Future<void> callFunction()async{
    users = await GetFriends.getUserFromString(searchText.text);
    setState(() {
      users = users;
    });
  }
}
