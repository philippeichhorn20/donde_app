import 'dart:io';

import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/MainViews/SpotView.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListTiles{

  static Widget userListTile (MyUser user, BuildContext context, ){
    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(title: Text(user.username,
          style: UITemplates.buttonTextStyle,
          ),
          tileColor: Colors.white12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
      ),

          trailing: TextButton.icon(onPressed: ()async{
             RelationshipFunctions.followUser(user);
            setState((){
              user.amFollowing = !user.amFollowing;
            });
          },
              icon: Icon(user.amFollowing?Icons.add_circle:Icons.add_circle_outline, color: Colors.white,), label: SizedBox()),),
        ),
      );
    },);
  }

  static Widget spotListTile (Spot spot, BuildContext context, ){
    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        width: 300,
        child: ListTile(title: Text(spot.name),
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => SpotView(spot),
              ),
            );
          },
         ),
      );
    },);
  }


  static Widget reviewListTile (Review review, BuildContext context, ){
    review.id = 8;
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    border: Border.all(color: !review.liked?Colors.red:Colors.green, width: 10,),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),

                    child: SizedBox(
                      width: 300,
                      child: FutureBuilder(
                        future: ReviewFunctions.getReviewPic(review),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState != ConnectionState.done || snapshot.data == null){
                            return const CircularProgressIndicator();
                          }
                        return Image.memory(snapshot.data!, fit: BoxFit.fill,);
                      },),
                    ),
                  ),
                ),
                Positioned(
                    child: Text(review.text,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),),
                bottom: 20,
                left: 10,
                ),
              ],
            ),
            Container(
              height: 30,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(review.createdAt != null)
                    Text("${review.createdAt!.day}.${review.createdAt!.month}.${review.createdAt!.year}"),
                  TextButton(
                    onPressed: () {
                      showSnackbar(context, review.author, setState);
                    },
                      child: Text("by ${review.author.username}"),),
                ],
              ),
            )
          ],
        ),
      );
    },
    );
  }
  
  
  static void showSnackbar(BuildContext context, MyUser user, Function setState){

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
duration: Duration(seconds: 7),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Row(
              children: [
                Text("${user.username}",
                ),
                Expanded(child: SizedBox()),
                ElevatedButton(
                    style: UITemplates.buttonStyle,
                    onPressed: (){
                    setState((){
                      user.amFollowing = !user.amFollowing;
                    });
                  RelationshipFunctions.followUser(user);
                }, child: Text(user.amFollowing? "Unfollow":"Follow" ))
              ],
        );
            }
          ),

        )
    );
    
  }
}