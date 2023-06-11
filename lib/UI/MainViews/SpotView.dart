import 'package:donde/BackendFunctions/Linking.dart';
import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/UI/BasicUIElements/PopUps.dart';
import 'package:donde/UI/BasicUIElements/SharePicView.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../ReviewFlow/AddReview.dart';

class SpotView extends StatefulWidget {
  final Spot spot;
  const SpotView(this.spot);

  @override
  _SpotViewState createState() => _SpotViewState();
}

class _SpotViewState extends State<SpotView> {
  late Future reviews;

   String ratingAvg = "...";
@override
  void initState() {
    // TODO: implement initState
    super.initState();

}

  @override
  Widget build(BuildContext context) {
    getReviews(widget.spot);
    return DefaultTextStyle(
      style: UITemplates.descriptionStyle,
      child: Container(
        /*    decoration: BoxDecoration(
          border: Border.all(color: Colors.white12, width: 3),
            borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
   */
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 15, bottom: 0, right: 40),
              child: Container(
                child: GestureDetector(
                  onTap: () async{
                    String link = await Linking.createLinkToUser();
                   Share.share(
                     "Meet me there: "+ widget.spot.name+" at "+widget.spot.adress+
                         "\nAdd me here: $link"
                   );
                  },
                  child: RichText(
                    text: TextSpan(
                      children:  <TextSpan>[
                        TextSpan(text: widget.spot.name,
                          style: UITemplates.nameStyle,),
                        TextSpan(text:  "\t\t•\t\tshare" ,
                          style: UITemplates.descriptionStyle,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 0, bottom: 2, right: 40),
              child: Container(
                child: RichText(
                  text: TextSpan(
                    children:  <TextSpan>[
                      TextSpan(text:  widget.spot.type.name,
                        style: UITemplates.clickableText,
                      ),
                      TextSpan(text: "\t\t•\t\t" + widget.spot.getDistance(),
                        style: UITemplates.clickableText,
                      ),
                      TextSpan(text:  "\t\t•\t\t ${ratingAvg} (${widget.spot.reviews.length})",
                        style: UITemplates.clickableText,
                      ),
                      TextSpan(text:  "\n" + widget.spot.adress,
                        style: UITemplates.descriptionStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 500,
              child: (widget.spot.reviews.length > 0)?
              PageView.builder(
                itemCount: widget.spot.reviews.length,
                itemBuilder: (context, index) {
                  if (widget.spot.reviews.length > index + 1) {
                    ReviewFunctions.getReviewPic(widget.spot.reviews[index + 1]);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: ListTiles.reviewListTile(
                        widget.spot.reviews[index], context, setState),
                  );
                },
                scrollDirection: Axis.horizontal,
              ):Center(child: UITemplates.loadingAnimation),
            ),

          ],
        ),
      ),
    );
  }

  Future<bool> getReviews(Spot spot) async {
    if (widget.spot.reviews == null || widget.spot.reviews.isEmpty) {
      print("database request");
      widget.spot.reviews = await ReviewFunctions.getReviews(spot);
    }
    if(widget.spot.reviews.length >0){
      setState(() {
        widget.spot.reviews = widget.spot.reviews;
        ratingAvg = widget.spot.getAverageRating();
      });
    }

    return true;
  }
}
