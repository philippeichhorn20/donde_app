import 'package:donde/BackendFunctions/GetFriends.dart';
import 'package:donde/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchUserView extends StatefulWidget {
  @override
  _SearchUserViewState createState() => _SearchUserViewState();
}

class _SearchUserViewState extends State<SearchUserView> {
  TextEditingController searchText = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: TextField(
            controller: searchText,
            cursorColor: Colors.black,
            style: UITemplates.descriptionStyle,
            autofocus: true,
            decoration: InputDecoration(
              fillColor: Colors.white12,
              hintText: "Find users",
              hintStyle: UITemplates.descriptionStyle,
              focusedBorder: UITemplates.appBarInputBorder,
              filled: true,
              border: UITemplates.appBarInputBorder,
              enabledBorder: UITemplates.appBarInputBorder,

            ),
            onChanged: (text){
              setState(() {
                searchText;
              });
            },
          ),
        ),
        body: Column(
          children: [
            FutureBuilder(
                future: GetFriends.getUserFromString(searchText.text),
                builder: (context, snapshot){
                  if(snapshot == null || snapshot.data == null || snapshot.data!.length ==0){
                    print("n0othing");
                    return SizedBox();
                  }
                  print(snapshot.data!.length.toString());

                  return Container(
                    child: Flexible(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot == null||snapshot.data == null?0:snapshot.data!.length,
                        itemBuilder: (context, index) {
                          MyUser user = snapshot.data![index];
                          return ListTiles.userListTile(user, context);
                        },
                      ),
                    ),
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
