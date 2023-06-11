import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/UI/CreateSpot/NewSpot.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DoesSpotExist extends StatefulWidget {
  final Review review;
  const DoesSpotExist(this.review);
  @override
  _DoesSpotExistState createState() => _DoesSpotExistState();
}

class _DoesSpotExistState extends State<DoesSpotExist> {
  TextEditingController searchText = TextEditingController();

  List<Spot> spots = [];
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsTheSpots("");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          title: TextField(
            controller: searchText,
            cursorColor: Colors.black,
            style: UITemplates.settingsTextStyle,
autofocus: true,
            decoration: InputDecoration(
              fillColor: Colors.white12,
              hintText: "search all spots",
              hintStyle: UITemplates.settingsTextStyle,
              focusedBorder: UITemplates.appBarInputBorder,
              filled: true,
              border: UITemplates.appBarInputBorder,
              enabledBorder: UITemplates.appBarInputBorder,

            ),
            onSubmitted: (value) {
              getsTheSpots(value);

            },
            onChanged: (text){
              setState(() {
                searchText.text = text;
              });
              if(text.length%2==0){
                getsTheSpots(text);
              }

            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:10.0, left: 10,right: 10),
              child: ListTile(
                onTap: (){
                  print(widget.review.pic != null);

                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => NewSpot(searchText.text, widget.review),
                    ),
                  );
                },
                title: Text(searchText.text, style: UITemplates.buttonTextStyle,),
                subtitle: Text("Click here if your spot was not found"),
                shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Colors.black54,
              ),
            ),
            if(loading)
              UITemplates.loadingAnimation,
            if(!loading)
              Container(
                child: Flexible(child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: spots.length,
                  itemBuilder: (context, index) {
                    Spot spot = spots[index];
              //      return ListTiles.spotListTile(spot, context, widget.review);
                  },
                ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> getsTheSpots(String str)async{
    setState(() {
      loading = true;
    });
    if(str == ""){
   //   spots = await SpotFunctions.getallspotsnearyou(Store.position!.latitude, Store.position!.longitude);
    }else{
  //    spots = await SpotFunctions.fulltextspotsearch(searchText.text);
    }
    setState(() {
      loading = false;
    });
  }
}
