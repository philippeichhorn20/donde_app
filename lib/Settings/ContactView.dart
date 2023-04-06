import 'package:donde/BackendFunctions/GetFriends.dart';
import 'package:donde/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/material.dart';

class ContactView extends StatefulWidget {

  final ContactTypes type;
  const ContactView(this.type);

  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: UITemplates.appbar(widget.type.name),
          body: Stack(
            alignment: Alignment.center,
            children: [
              FutureBuilder(
                  future: getUsers(widget.type),
                  builder: (context, snapshot){
                    if(snapshot == null || snapshot.data == null || snapshot.data!.length ==0){
                      return SizedBox();
                    }
                    return ListView.builder(
                      itemCount: snapshot == null||snapshot.data == null?0:snapshot.data!.length,
                      itemBuilder: (context, index) {
                        MyUser user = snapshot.data![index];
                        return ListTiles.userListTile(user, context);
                      },
                    );
                  }),
            ],
          )
      ),
    );
  }

  Future<List<MyUser>> getUsers(ContactTypes type)async{
    switch (type){
      case ContactTypes.FOLLOWER:
        return await GetFriends.getPeopleThatFollowMe();
        break;
      case ContactTypes.FOLLOWING:
        return await GetFriends.getPeopleIFollow();
        break;
      case ContactTypes.PROPOSALS:
        return await GetFriends.getFriendsFromContact("");
        break;
    }
  }
}


enum ContactTypes{
  FOLLOWER, FOLLOWING, PROPOSALS
}