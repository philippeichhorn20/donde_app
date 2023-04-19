import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/material.dart';

class MyReviews extends StatefulWidget {
  @override
  _MyReviewsState createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  List<Review> reviews = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myReviews();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: UITemplates.appbar("MyReviews"),
        body: Container(
          alignment: Alignment.bottomCenter,
          child: PageView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              if(reviews.length > index+1){
                ReviewFunctions.getReviewPic(reviews[index+1]);
              }
              return Padding(
                padding: const EdgeInsets.only(top:30.0),
                child: ListTiles.reviewListTile(reviews[index], context, setState),
              );
            },
            scrollDirection: Axis.horizontal,

          ),
        ),
      ),

    );
  }

  Future<void> myReviews()async{
    reviews = await ReviewFunctions.getMyReviews();
    setState(() {
      reviews = reviews;
    });
  }

}
