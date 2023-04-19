import 'dart:io';
import 'dart:ui';

import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/BackendFunctions/RelationshipFunctions.dart';
import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/UI/BasicUIElements/PopUps.dart';
import 'package:donde/UI/MainViews/HomePage.dart';
import 'package:donde/UI/ReviewFlow/AddReview.dart';
import 'package:donde/UI/MainViews/SpotView.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';


// userListTile,spotListTile, reviewListTile, showSnackbar

class ListTiles{

  static Widget userListTile (MyUser user, BuildContext context,{Function? action} ){
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

          trailing: UITemplates.relationShipIndicator(user),),
        ),
      );
    },
    );
  }

  static Widget spotListTile (Spot spot, BuildContext context, Review review){

    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.only(top:10.0, left: 10,right: 10),
        child: ListTile(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
          ),
          tileColor: Colors.white12,
         // minVerticalPadding: 10,
          title: Text(spot.name,),
          subtitle: Text(spot.adress, ),
          onTap: () async{
            ReviewFunctions.saveReview((await Review.addReview(review.text, spot, review.rating??0, review.textColor??0, review.image))!);
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (context) => AddReview(),
              ),
            );
            setState((){
              Store.pers_controller!.index = 0;
            });

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
        height: 570,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: SizedBox(
                      width: 350,
                      height: 450,
                      child: FutureBuilder(
                        future: reviewPic,
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return UITemplates.loadingAnimation;
                          }
                          if(snapshot.data == null){
                            return const Center(child: Icon(Icons.error, color: Colors.grey,size: 40,),);
                          }
                        return ImageFiltered(
                            imageFilter: review.author.relationshipType == RelationshipTypes.FRIEND||
                                review.author.relationshipType == RelationshipTypes.ME
                            ? ImageFilter.blur(sigmaX: 0, sigmaY: 0):ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                            child: Image.memory(snapshot.data!, fit: BoxFit.cover,));
                      },),
                    ),
                  ),
                ),
                if(review.author.relationshipType != RelationshipTypes.FRIEND&&
                    review.author.relationshipType != RelationshipTypes.ME)
                Positioned(
                  top: 20,
                  child: Container(
                    width:MediaQuery.of(context).size.width*.4,
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.group, size: 35, color: Colors.white,),
                        Text("Befriend ${review.author.username} to see the picture", textAlign: TextAlign.center, style: UITemplates.descriptionStyle,),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 20,
                left: 10,
                    child: Container(
                      width: MediaQuery.of(context).size.width*.8,
                      padding: EdgeInsets.only(left:20,right:20,top:10,bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Text(review.text,
                      style: UITemplates.reviewExperienceStyle,),
                    ),
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
                      child: TextButton(
                        style:  TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          foregroundColor: Colors.transparent,
                        ),

                        onPressed: ()async {
                        await ReviewFunctions.deleteReview(review);
                        setGenState((){
                          review.spot!.reviews!.remove(review);
                        });
                      },
                        child: Icon(Icons.delete_forever, color: Colors.white,),
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top:2.0, left: 30),
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0, right:8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(review.createdAt != null)
                        Text("${review.createdAt!.day}.${review.createdAt!.month}.${review.createdAt!.year}", style: UITemplates.reviewNoteStyle,),
                      Text("\t•\tby ${review.author.username}\t",
                        style: UITemplates.reviewNoteStyle,
                      ),
                      if(review.author.relationshipType != RelationshipTypes.FRIEND && review.author.relationshipType != RelationshipTypes.ME)
                      UITemplates.relationShipIndicator(review.author),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: RatingBar(ratingWidget: UITemplates.ratingBarItem, onRatingUpdate: (double value) {},
                          initialRating: (review.rating??0).toDouble(),
                          ignoreGestures: true,
                          itemCount: 5,
                          itemSize: 16,
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(

                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size.zero,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                        onPressed: (){
                        //call the reportsnackbar from popups class
                        ScaffoldMessenger.of(context).showSnackBar(PopUps.reportSnackbar(context, review));

                      }, child: Icon(Icons.more_horiz),)
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
  
  
  static SnackBar showSnackbar(MyUser user){

        return SnackBar(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
duration: Duration(days: 300),
          behavior: SnackBarBehavior.floating,
          content: Container(
            height: 100,
            alignment: Alignment.topCenter,

            child: StatefulBuilder(
              builder: (context, setState) {
                return Row(
                children: [
                  Text("${user.username}",
                    style: UITemplates.importantTextStyle,
                  ),
                  Expanded(child: SizedBox()),
                  if(user.relationshipType != RelationshipTypes.ME)
                  UITemplates.relationShipIndicator(user),
                ],
        );
              }
            ),
          ),

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