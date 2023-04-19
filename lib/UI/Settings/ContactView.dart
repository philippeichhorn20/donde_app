import 'package:donde/BackendFunctions/FriendRelationshipGroups.dart';
import 'package:donde/BackendFunctions/GetFriends.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
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
  List<MyUser> users = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers(widget.type);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(

          resizeToAvoidBottomInset: false,

          appBar: UITemplates.appbar(widget.type.name),
          body: Stack(
            alignment: Alignment.center,
            children: [
              RefreshIndicator(
                onRefresh: ()async {
                  await getUsers(widget.type);
                },
                child:  ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    MyUser user = users[index];
                    return ListTiles.userListTile(user, context);
                  },
                ),
              ),
            ],
          )
      ),
    );
  }

  Future<void> getUsers(ContactTypes type)async{
    switch (type){
      case ContactTypes.REQUESTS:
        users =  await FriendRelationshipGroups.getRequestingUsers();
        break;
      case ContactTypes.FRIENDS:
        users =  await FriendRelationshipGroups.getFriends();
        break;
      case ContactTypes.PROPOSALS:
        users =  await GetFriends.getFriendsFromContact("");
        break;
        case ContactTypes.MY_REQUESTS:
      users =  await FriendRelationshipGroups.getPeopleIRequested();
      break;
    }
    setState(() {
      users = users;
    });
  }
}


enum ContactTypes{
  REQUESTS, FRIENDS, PROPOSALS, MY_REQUESTS
}