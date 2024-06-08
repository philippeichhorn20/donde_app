import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/BackendFunctions/TomTomSpotSearch.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Store.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/UI/BasicUIElements/PopUps.dart';
import 'package:donde/UI/ReviewFlow/AddReview.dart';
import 'package:donde/UI/MainViews/HomePage.dart';
import 'package:donde/UI/MainViews/SpotView.dart';
import 'package:donde/UI/ReviewFlow/PostCheck.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class NewSpotLocation extends StatefulWidget {
  final String name;
  final String description;
  final SpotTypes type;
  final Review review;
  NewSpotLocation(this.name,this.description,this.type, this.review);

  @override
  _NewSpotLocationState createState() => _NewSpotLocationState();
}

class _NewSpotLocationState extends State<NewSpotLocation> {
  TextEditingController street = TextEditingController();
  Location? location;

  Map<Placemark,Location> countries = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          bottomOpacity: 0,
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*.8,
                    child: TextField(
                      autofocus: true,
                      cursorColor: Colors.black,

                      controller: street,
                      decoration:InputDecoration(
                        fillColor: Colors.white12,
                        hintText: "Street",

                        hintStyle: UITemplates.descriptionStyle,
                        focusedBorder: UITemplates.appBarInputBorder,
                        filled: true,
                        border: UITemplates.appBarInputBorder,
                        enabledBorder: UITemplates.appBarInputBorder,
                      ),
                      onSubmitted: (value) async{
                        TomTomSpotSearch.getSpots(true, value);

                      },
                      onChanged: (value) async{
                        TomTomSpotSearch.getSpots(true, value);
                        /*
                        if(value.length%2 == 0){
                          countries= await getCountriesFromAdress(street.text);
                          setState(() {
                            countries = countries;
                          }
                      );


                        }
   */
                      },
                    ),
                  ),
                  SizedBox(height: 100,),
                  Container(
                    padding: EdgeInsets.only(left:20, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text("Select the closest adress to safe the new spot",
                      textAlign: TextAlign.left,
                      style: UITemplates.descriptionStyle,),
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      MapEntry<Placemark,Location> country = countries.entries.elementAt(index);
                      return ListTile(
                        onTap: () async{
                          setState(() {
                            location = country.value;
                          });
                          Spot? spot = await saveSpot();
                          Review? review;
                          if(spot!= null){
                             review = await Review.addReview(widget.review.text, spot, widget.review.rating??0, widget.review.textColor??0, widget.review.image);
                            if(review == null){
                              UITemplates.showErrorMessage(context, "Please try again, later");
                            }
                          }else{
                            UITemplates.showErrorMessage(context, "Please try again later");
                          }
                          if(spot != null&& review != null){
                            spot.reviews.add(review);
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => PostCheck(spot: spot, review: review!),
                              ),
                            );

                          }else{
                            UITemplates.showErrorMessage(context, "Make sure everything is complete");
                          }
                        },
                        title: Text(country.key.street!),
                        subtitle:  Text(country.key.locality!+", "+ country.key.country!),
                        tileColor: country.value != location?Colors.white12:Colors.grey,);
                    },
                  ),

                ],
              ),
              Positioned(
                bottom: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("I am here now, so...", style: UITemplates.descriptionStyle,),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width*.8,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: ()async{
                  //            await fillWithCurrentLocation();
                              Spot? spot = await saveSpot();
                              Review? review;
                              if(spot!= null){
                                 review = await widget.review;
                             if(review == null){
                               UITemplates.showErrorMessage(context, "Please try again later");
                             }
                              }else{
                                UITemplates.showErrorMessage(context, "Please try again later");
                              }


                              if(spot != null && review != null){
                                spot.reviews.add(review);
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => PostCheck(spot: spot, review: review!),
                                  ),
                                );

                              }else{
                                UITemplates.showErrorMessage(context, "Please, try again");
                              }
                            },
                            child: Text("use my location", style: UITemplates.buttonTextStyle,),
                            style: UITemplates.buttonStyle,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<Spot?> saveSpot()async{
    if(location== null) return null;
    Spot spot = Spot(widget.name, 0, 0, street.text, widget.description, widget.type);
    spot.lat = location!.latitude;
    spot.long = location!.longitude;

    return spot;
  }

  Future<Spot?> saveSpotFromList()async{
    Spot spot = Spot(widget.name, 0, 0, street.text, widget.description, widget.type);
    spot.lat = location!.latitude;
    spot.long = location!.longitude;

    return spot;
  }


  Future<Map<Placemark,Location>> getCountriesFromAdress(String str)async{
    List<Location> locations = await LocationServices.getLocationsFromString(str);
    Map<Placemark,Location> countriesMaps = {};
    await Future.forEach(locations, (element) async {
      Placemark? countryStr = (await placemarkFromCoordinates(element.latitude, element.longitude)).first;
      if(countryStr!= null){
        countriesMaps.addAll({countryStr:element});
      }
    });
    return countriesMaps;
  }
}
