import 'package:donde/BackendFunctions/GetFriends.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Store.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/material.dart';

class ReactionView extends StatefulWidget {
  final Review review;
  final int index;
  const ReactionView({Key? key, required this.review, required this.index}) : super(key: key);

  @override
  State<ReactionView> createState() => _ReactionViewState();
}

class _ReactionViewState extends State<ReactionView> with SingleTickerProviderStateMixin{



  List<MyUser> usersLoved = [];
  List<MyUser> usersBeen = [];
  List<MyUser> usersHearted = [];

  @override
  void initState() {
    // TODO: implement initState
    getReactingUsers(Reactions.LOVE);
    getReactingUsers(Reactions.HEART);
    getReactingUsers(Reactions.BEEN);


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3,
        initialIndex: widget.index,
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Reactions", style: UITemplates.importantTextStyle,),
        bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
          Tab(
            icon: Text("❤️", style: TextStyle(fontSize: 30),),
          ),
          Tab(
            icon: Text("Been there", style: UITemplates.numberOnReactionStyle,),
          ),
          Tab(
            icon: Text("Loved it!️", style: UITemplates.numberOnReactionStyle,),
          ),
        ]),
      ),
      body: TabBarView(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(bottom: 60),
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            itemCount: usersHearted.length,
            itemBuilder: (context, index) {
              MyUser user = usersHearted[index];
              return ListTiles.userListTile(user, context);
            },
          ),
          ListView.builder(
            padding: EdgeInsets.only(bottom: 60),
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            itemCount: usersBeen.length,
            itemBuilder: (context, index) {
              MyUser user = usersBeen[index];
              return ListTiles.userListTile(user, context);
            },
          ),
          ListView.builder(
            padding: EdgeInsets.only(bottom: 60),
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            itemCount: usersLoved.length,
            itemBuilder: (context, index) {
              MyUser user = usersLoved[index];
              return ListTiles.userListTile(user, context);
            },
          ),
        ],
      ),
    ));
  }


  Future<void> getReactingUsers(Reactions reaction)async{


    List<MyUser> users = await GetFriends.getreactingusers(widget.review, reaction);



    switch (reaction) {
      case Reactions.HEART:
        setState(() {
          usersHearted = users;
          if(widget.review.iHeart){
            users.add(Store.me);
          }
        });
        break;
      case Reactions.BEEN:
        setState(() {
          usersBeen = users;
          if(widget.review.iveBeen){
            users.add(Store.me);
          }
        });
        break;
      case Reactions.LOVE:
        setState(() {
          usersLoved = users;
          if(widget.review.iLoveIt){
            users.add(Store.me);
          }
        });
        break;
    }

  }
}
