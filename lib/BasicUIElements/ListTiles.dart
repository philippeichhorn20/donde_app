import 'dart:io';

import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/MainViews/AddReview.dart';
import 'package:donde/MainViews/SpotView.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';


// userListTile,spotListTile, reviewListTile, showSnackbar

class ListTiles{

  static Widget userListTile (MyUser user, BuildContext context, ){
    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(

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
    },
    );
  }

  static Widget spotListTile (Spot spot, BuildContext context, ){

    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.only(top:10.0, left: 10,right: 10),
        child: ListTile(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
          ),
          tileColor: Colors.white12,
          minVerticalPadding: 10,
          title: Text(spot.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(spot.description,style: UITemplates.descriptionStyle,),
              Text(spot.adress, )
            ],
          ),

          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => AddReview(spot),
              ),
            );
          },
         ),
      );
    },);
  }


  static Widget reviewListTile (Review review, BuildContext context,Function setGenState ){
    late Future reviewPic;
    reviewPic = ReviewFunctions.getReviewPic(review);

    return StatefulBuilder(builder: (context, setState) {
      return Container(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),

                    child: SizedBox(
                      width: 350,
                      height: 500,
                      child: FutureBuilder(
                        future: reviewPic,
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return UITemplates.loadingAnimation;
                          }
                          if(snapshot.data == null){
                            return const Center(child: Icon(Icons.error, color: Colors.grey,size: 40,),);
                          }
                        return Image.memory(snapshot.data!, fit: BoxFit.cover,);
                      },),
                    ),
                  ),
                ),
                Positioned(
                    child: Text(review.text,
                    style: UITemplates.reviewText(review.textColor??0),),
                bottom: 20,
                left: 10,
                ),
                if(review.author.id == Store.me.id)
                Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: TextButton(onPressed: ()async {
                        await ReviewFunctions.deleteReview(review);
                        setGenState((){
                          review.spot.reviews!.remove(review);
                        });
                      },
                        child: Icon(Icons.delete_forever, color: Colors.white,),
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top:5.0, left: 10),
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(review.createdAt != null)
                        Text("${review.createdAt!.day}.${review.createdAt!.month}.${review.createdAt!.year}", style: UITemplates.descriptionStyle,),
                      Text("\t•\tby ${review.author.username}\t•\t",
                        style: UITemplates.descriptionStyle,
                      ),
                      if(!review.author.amFollowing)
                      ElevatedButton(
                        onPressed: () async{
                          await RelationshipFunctions.followUser(review.author);
                          setState((){
                            review.author.amFollowing = review.author.amFollowing;
                            print(review.author.amFollowing);
                          });
                        },
                        style: ElevatedButton.styleFrom(

                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.only(top:3, bottom: 3,left: 5, right: 5),
                          minimumSize: Size.zero,
                          backgroundColor: review.author.amFollowing?Colors.grey:Colors.grey,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),),

                          child: Text((review.author.amFollowing?"unfollow":"follow"),
                          style: TextStyle(
                            color: review.author.amFollowing?Colors.white24:Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                          ),

                          ),

                      ),

                    ],
                  ),
                ),
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
  static Widget showLocations(Location location){
    return SizedBox(

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Transform.rotate(angle: LocationServices.getDirection(location),child: Icon(Icons.arrow_forward),),
          title: Text(LocationServices.getDistance(location).toString(),
          style: UITemplates.buttonTextStyle,
        ),
          tileColor: Colors.white12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );

  }
}