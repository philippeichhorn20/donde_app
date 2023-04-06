import 'package:donde/BackendFunctions/Linking.dart';
import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'AddReview.dart';

class SpotView extends StatefulWidget {
  final Spot spot;
  const SpotView(this.spot);

  @override
  _SpotViewState createState() => _SpotViewState();
}

class _SpotViewState extends State<SpotView> {
  late Future reviews;

  @override
  Widget build(BuildContext context) {
    getReviews(widget.spot);
    return Container(
      /*    decoration: BoxDecoration(
        border: Border.all(color: Colors.white12, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
   */
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 18),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200,
                  minHeight: 0,
                  maxWidth: MediaQuery.of(context).size.width*.8,
                ),

              child: RichText(
                text: TextSpan(
                  children:  <TextSpan>[
                    TextSpan(text: widget.spot.name,
                      style: UITemplates.nameStyle,),
                    TextSpan(text: "\t\t•\t\t" + widget.spot.getDistance(),
                      style: UITemplates.descriptionStyle,
                    ),
                    TextSpan(text:  "\t\t•\t\t" + widget.spot.type.name,
                      style: UITemplates.descriptionStyle,

                    ),

                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 18, top: 10),
            child: Text(
              widget.spot.description,
              style: UITemplates.descriptionStyle,
            ),
          ),
          Container(
            height: 600,
            child: (widget.spot.reviews!=null && widget.spot.reviews!.length > 0)?
            PageView.builder(
              itemCount: widget.spot.reviews!.length,
              itemBuilder: (context, index) {
                if (widget.spot.reviews!.length > index + 1) {
                  ReviewFunctions.getReviewPic(widget.spot.reviews![index + 1]);
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ListTiles.reviewListTile(
                      widget.spot.reviews![index], context, setState),
                );
              },
              scrollDirection: Axis.horizontal,
            ):Center(child: UITemplates.loadingAnimation),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 4),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => AddReview(widget.spot),
                        ),
                      );
                    },
                    style: UITemplates.buttonStyle,
                    child: Text(
                      "add review",
                      style: UITemplates.buttonTextStyle,
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: TextButton(
                    onPressed: () async{
                      await Share.share( (await Linking.createLinkToSpot(widget.spot)).toString());
                    },
                    style: UITemplates.buttonStyle,
                    child: Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> getReviews(Spot spot) async {

    if (widget.spot.reviews == null || widget.spot.reviews!.isEmpty) {
      print("reviews loading");

      widget.spot.reviews = await ReviewFunctions.getReviews(spot);
    }
    print("reviews arrived");
    setState(() {
      widget.spot.reviews = widget.spot.reviews;
    });
    return true;
  }
}
