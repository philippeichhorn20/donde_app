import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AddReview.dart';

class SpotView extends StatefulWidget {
  final Spot spot;
  const SpotView(this.spot);

  @override
  _SpotViewState createState() => _SpotViewState();
}

class _SpotViewState extends State<SpotView> {

  late Future reviews;
  initState(){
    super.initState();
    reviews = getReviews(widget.spot);
  }


  @override
  Widget build(BuildContext context) {

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
            padding: const EdgeInsets.only(top:10.0, left: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.spot.name,
                style: UITemplates.nameStyle,
                ),
                Text("\t\t"+widget.spot.type.name,
                  style: UITemplates.descriptionStyle,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:10.0, left: 18, top:10),
            child: Text(widget.spot.description,
              style: UITemplates.descriptionStyle,
            ),
          ),

          FutureBuilder(
              future: reviews,
              builder: (context, snapshot) {
                if(widget.spot.reviews == null || snapshot.data == null || widget.spot.reviews!.length == 0){
                  return SizedBox();
                }
                return Container(
                  height: 600,
                  child: PageView.builder(
                    itemCount: widget.spot.reviews!.length,
                    itemBuilder: (context, index) {
                      if(widget.spot.reviews!.length > index+1){
                        ReviewFunctions.getReviewPic(widget.spot.reviews![index+1]);
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top:30.0),
                        child: ListTiles.reviewListTile(widget.spot.reviews![index], context, setState),
                      );
                    },
                    scrollDirection: Axis.horizontal,

                  ),
                );
              }
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 4),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.6,
                  child: TextButton(
                    onPressed: (){
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => AddReview(widget.spot),
                      ),
                    );
                  },

                    style: UITemplates.buttonStyle,
                    child: Text("add review", style: UITemplates.buttonTextStyle,),
                  ),
                ),
                Expanded(child: SizedBox()),
                Container(
                  width: MediaQuery.of(context).size.width*0.2,
                  child: TextButton(
                    onPressed: (){

                    },

                    style: UITemplates.buttonStyle,
                    child: Icon(Icons.share, color: Colors.white,size: 25,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Review>> getReviews(Spot spot){
    print("gettingrevs;");
    return ReviewFunctions.getReviews(spot);
  }

}
