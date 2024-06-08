import 'package:donde/Classes/Spot.dart';
import 'package:donde/Store.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
import 'package:donde/UI/MainViews/SpotView.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/material.dart';

class FeedView extends StatefulWidget {
  final List<Spot> spotList;
  final Function(double, bool) forceNewSpots;
  final builderKey;

  const FeedView({Key? key,required this.forceNewSpots, required this.spotList, required this.builderKey}) : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return
      RefreshIndicator(
        onRefresh: () async {
          await widget.forceNewSpots(50, true);
        },
        color: Colors.white,
        backgroundColor: Colors.black,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.spotList.length + 1,
          key: widget.builderKey,
          itemBuilder: (context, index) {
            if (index == widget.spotList.length) {

              if(widget.spotList.isEmpty){
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Icon(
                          Icons.group,
                          size: 50,
                        ),
                      ),
                      Text(
                        "No Results found",
                        style: UITemplates.buttonTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "add friends or create reviews",
                        style: UITemplates.clickableText,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return SizedBox(
                height: 200,
              );
            }

            Spot spot = widget.spotList[index];

            if(spot.isAd){
              return ListTiles.AdSpotWidget((){
                Store.pers_controller!.index = 1;
              }, context);
            }
            return Container(
                width: MediaQuery.of(context).size.width,
                child: SpotView(spot, (){}));
          },
        ),
      );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive =>  true;
}
