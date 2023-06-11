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
  bool loading = false;
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

          appBar: UITemplates.appbar(contacttypesToName(widget.type)),
          body: Stack(
            alignment: Alignment.center,
            children: [
              RefreshIndicator(
                onRefresh: ()async {
                  await getUsers(widget.type);
                },
                color: Colors.black,
                child:  ListView.builder(
                  itemCount: users.length == 0 && !loading ? 1 : users.length,
                  itemBuilder: (context, index) {
                    if(users.length == 0 && !loading){
                      return Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Icon(
                                  Icons.group,
                                  size: 50,
                                ),
                              ),
                              Text(
                                "No Results found",
                                style: UITemplates.buttonTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ]),);
                    }
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
    setState(() {
      loading = true;
    });
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
      loading = false;
    });
  }


  static String contacttypesToName(ContactTypes type){

    switch (type){

      case ContactTypes.REQUESTS:
        return "Open Requests";
        break;
      case ContactTypes.FRIENDS:
        return "Friends";
        break;
      case ContactTypes.PROPOSALS:
        return "Find Friends";
        break;
      case ContactTypes.MY_REQUESTS:
        return "Sent Requests";
        break;
    }
  }
}


enum ContactTypes{
  REQUESTS, FRIENDS, PROPOSALS, MY_REQUESTS
}