import 'dart:io';

import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/Store.dart';
import 'package:donde/UI/CreateSpot/NewSpot.dart';
import 'package:donde/UI/ReviewFlow/DoesSpotExistView.dart';
import 'package:donde/UITemplates.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profanity_filter/profanity_filter.dart';

class ReviewDetailsView extends StatefulWidget {
  final File pic;
  const ReviewDetailsView({Key? key, required this.pic}) : super(key: key);

  @override
  State<ReviewDetailsView> createState() => _ReviewDetailsViewState();
}

class _ReviewDetailsViewState extends State<ReviewDetailsView> {
  int? rating;
  TextEditingController textControl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAnalytics.instance.logEvent(name: "creates review step 1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        child: SingleChildScrollView(

          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Add a note",
                    style: UITemplates.descriptionStyle,
                  )),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  maxLines: 3,
                  cursorColor: Colors.black,
                  style: UITemplates.reviewExperienceStyle,
                  //reviewexperiencestyle
                  autofocus: true,
                  controller: textControl,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter
                  ],
                  decoration: InputDecoration(
                      hintText: "How was your experience?",
                      fillColor: Colors.black26,
                      focusColor: Colors.black26,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none)),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*.05,
              ),
              Container(
                  padding: EdgeInsets.only(left: 30, top: 20, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Leave a rating",
                    style: UITemplates.descriptionStyle,
                  )),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                child: RatingBar(
                  ratingWidget: UITemplates.ratingBarItem,
glow: false,
                  itemPadding: EdgeInsets.only(left: 10, right: 10),
                  allowHalfRating: false,
                  onRatingUpdate: (value) async {
                    rating = value.toInt();
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*.25,),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * .8,
                child: TextButton(
                  style: UITemplates.buttonStyle,
                  onPressed: () async {
                    var filter = ProfanityFilter();
                    if (textControl.text.isEmpty) {
                      UITemplates.showErrorMessage(context, "Add a note");
                    } else if (rating == null) {
                      UITemplates.showErrorMessage(
                          context, "Leave a rating between 0 and 5");
                    }else if (filter.hasProfanity(textControl.text)) {
                      UITemplates.showErrorMessage(
                          context, "Do not use bad language");
                    } else {
                      moveOn();
                    }
                  },
                  child: Text("next", style: UITemplates.buttonTextStyle),
                ),
              ),
              SizedBox(height: 56,)
            ],
          ),
        ),
      ),
    );
  }

  void moveOn() async{
    Review review = Review(textControl.text, Store.me, null, rating);
    review.textColor = 0;
    review.image = widget.pic;
    try{
      review.pic = await widget.pic.readAsBytes();
    }catch(e){
      print(e);
    }
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => NewSpot("", review),
      ),
    );
  }
}
