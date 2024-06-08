import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/BackendFunctions/TomTomSpotSearch.dart';
import 'package:donde/Classes/RawSpot.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/Store.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
import 'package:donde/UI/CreateSpot/NewSpotLocation.dart';
import 'package:donde/UI/MainViews/HomePage.dart';
import 'package:donde/UI/MainViews/SpotView.dart';
import 'package:donde/UI/ReviewFlow/AddReview.dart';
import 'package:donde/UITemplates.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:geocoding/geocoding.dart';

class NewSpot extends StatefulWidget {
  final String name;
  final Review review;

  const NewSpot(this.name, this.review);

  @override
  _NewSpotState createState() => _NewSpotState();
}

class _NewSpotState extends State<NewSpot> {
  TextEditingController nameControl = TextEditingController();
  TextEditingController descriptionControl = TextEditingController();
  TextEditingController searchText = TextEditingController();
  SuggestionsBoxController suggControl = SuggestionsBoxController();
  String adress = "";
  int spotTypeIndex = -1;
  Location? location;
  int? id;
  Spot? spot;
  RawSpot? rawSpot;
  bool isUploading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameControl.text = widget.name;
    FirebaseAnalytics.instance.logEvent(name: "creates review step 1");

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          bottomOpacity: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * .70,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0, left: 10,right:10),
                  child: TypeAheadField(
                    animationDuration: Duration.zero,
                    debounceDuration: Duration.zero,
                    suggestionsBoxController: suggControl,
                    loadingBuilder: (context) {
                      return UITemplates.loadingAnimation;
                    },
                    animationStart: 0,
                    itemBuilder: (context, itemData) {
                      return ListTiles.spotListTile(itemData, context);
                   },
                    textFieldConfiguration: TextFieldConfiguration(
                      onSubmitted: (value) {
                        getsTheSpots(value, false);
                      },
                      autofocus: true,
                      cursorColor: Colors.black,
                      controller: searchText,
                      decoration: InputDecoration(
                        suffixIcon: ElevatedButton(
                          child: Icon(Icons.close, color: Colors.white,),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                          ),
                          onPressed: (){
                            setState(() {
                              suggControl.suggestionsBox?.close();
                              searchText.text ="";
                            });
                          },
                        ),
                        fillColor: Colors.white12,
                        hintText: "Find the location",
                        hintStyle: UITemplates.descriptionStyle,
                        focusedBorder: UITemplates.appBarInputBorder,
                        filled: true,
                        border: UITemplates.appBarInputBorder,
                        enabledBorder: UITemplates.appBarInputBorder,
                      ),
                    ),
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      elevation: 0,
                    ),

                    keepSuggestionsOnLoading: true,
                    noItemsFoundBuilder: (context) {
                      return Container(
                        alignment: Alignment.center,
                        height: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Icon(
                                Icons.report_problem_outlined,
                                size: 50,
                              ),
                            ),
                            Text(
                              "No Places found",
                              style: UITemplates.buttonTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Maybe add the adress",
                              style: UITemplates.clickableText,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                    suggestionsCallback: (String pattern){
                        return getsTheSpots(pattern, false);
                      },
                //    hideKeyboard: true,
                    hideSuggestionsOnKeyboardHide: false,
                    errorBuilder: (context, error) {
                      print(error.toString());
                      try{

                      }catch(e){
                        print((error as Error).stackTrace);

                      }
                      return SizedBox();
                    },
                    getImmediateSuggestions: false,
                    onSuggestionSelected: (RawSpot suggestion) {
                      setState(() {
                        adress = suggestion.adress;
                        nameControl.text = suggestion.name;
                        location = suggestion.latlong;
                        print(location);
                        if(suggestion.runtimeType == Spot){
                          spotTypeIndex = (suggestion as Spot).type.index;
                          id =  suggestion.id;
                        }else{
                          id = null;
                          spotTypeIndex = -1;
                        }
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left:20),
                  alignment: Alignment.bottomLeft,
                  child: Text("Choose the location you want to rate", style: UITemplates.descriptionStyle,textAlign: TextAlign.start,)
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, left: 15, right:15, top:10),
                  padding: EdgeInsets.only(left:30, bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right:25.0),
                        child: TextField(
                          controller: nameControl,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder:  UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            hintText: "Name",
                            hintStyle: UITemplates.importantTextStyleHint,
                          ),
                          style: UITemplates.importantTextStyle,
                          enabled: id == null && adress != "",
                          onChanged: (value) {
                            id = null;
                          },
                        ),
                      ),
                      if(adress != null && adress != "")
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(top:20, bottom: 20),
                            child: Text(adress, style: UITemplates.descriptionStyle,textAlign: TextAlign.start,)),
                      if(adress == "")
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(top:20, bottom: 20),
                            child: Text("Find the location", style: UITemplates.descriptionStyle,textAlign: TextAlign.start,)),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                            spacing: 5,
                            children: List<Widget>.generate(
                              SpotTypes.values.length,
                                  (index) {
                                return ChoiceChip(
                                  padding: EdgeInsets.zero,
                                  label: Text(SpotTypes.values[index].name),
                                  selected: index == spotTypeIndex,
                                  onSelected: ((value) {
                                    if(id == null){
                                      setState(() {
                                        spotTypeIndex = index;
                                      });
                                    }else{
                                      UITemplates.showErrorMessage(context, "This location has already been used and therefore cannot be edited");
                                    }
                                  }),
                                  selectedColor: Colors.black45,
                                  backgroundColor: Colors.white12,
                                );
                              },
                            )),
                      ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * .8,
                  child: TextButton(
                    style: UITemplates.buttonStyle,
                    onPressed: () async {
                      if(!isUploading){
                        setState(() {
                          isUploading = true;
                        });
                      if (!await save()) {
                        UITemplates.showErrorMessage(context, "Add all the details");
                      } else {
                       // Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(
                            builder: (context) => AddReview(),
                          ),
                        );

                        setState(() {
                          Store.pers_controller!.index = 0;
                        });
                      }
                      setState(() {
                        isUploading = false;
                      });
                      }
                    },
                    child: isUploading ? Center(child: UITemplates.loadingAnimation,):Text("Post!", style: UITemplates.buttonTextStyle),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }




List<RawSpot> spots = [];
  Future<List<RawSpot>> getsTheSpots(String str, bool isTypeahead)async{
    print("here");


    if(str == ""){
      spots = (await SpotFunctions.getallspotsnearyou(Store.position!.latitude, Store.position!.longitude)).reversed.toList();
    }else{
      spots = (await SpotFunctions.fulltextspotsearch(str)).reversed.toList();
    }
    RawSpot? here = await LocationServices.getAdressOfCurrentLocation();
    if(here != null){
      spots.insert(0, here);
    }
    print("str: ${str}");
    if(spots.length < 3){
      spots.addAll((await TomTomSpotSearch.getSpots(isTypeahead, str.replaceAll(",", ""))));
    }
    setState(() {
      spots = spots;
    });
    return spots;
  }


  Future<bool> save()async{

    if(adress == "" || spotTypeIndex == -1 ||nameControl.text.isEmpty ||location == null ){
      return false;
    }

    Spot spot = Spot(nameControl.text,0,0,adress,"",SpotTypes.values[spotTypeIndex]);
    spot.latlong = location;
    spot.lat = location!.latitude;
    spot.long = location!.longitude;
    if(id == null){
      if(!await SpotFunctions.saveSpot(spot)){
        print("here2");
        return false;
      }
    }else{
      spot.id = id;
    }
    widget.review.spot = spot;
    print("her1e");
    return ReviewFunctions.saveReview(widget.review);
  }
}
