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
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white12, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(20)),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:18.0, left: 18),
            child: Text(widget.spot.name,
            style: UITemplates.nameStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:18.0, left: 18),
            child: Text(widget.spot.description,
              style: UITemplates.descriptionStyle,
            ),
          ),

          FutureBuilder(
              future: getReviews(widget.spot),
              builder: (context, snapshot) {
                if(snapshot == null || snapshot.data == null || snapshot.data!.length ==0){
                  return SizedBox();
                }
                return Container(
                  height: 400,
                  child: PageView.builder(
                    itemCount: snapshot.data!.length,

                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: ListTiles.reviewListTile(snapshot.data![index], context),
                      );
                    },
                    scrollDirection: Axis.horizontal,

                  ),
                );
              }
          ),
          TextButton(
            onPressed: (){
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => AddReview(widget.spot),
              ),
            );
          },
            child: Text("add review"),
          ),
        ],
      ),
    );
  }

  Future<List<Review>> getReviews(Spot spot){
    return ReviewFunctions.getReviews(spot);
  }

}
