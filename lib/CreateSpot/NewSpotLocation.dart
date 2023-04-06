import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/MainViews/AddReview.dart';
import 'package:donde/MainViews/HomePage.dart';
import 'package:donde/MainViews/SpotView.dart';
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
  NewSpotLocation(this.name,this.description,this.type);

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
                      onChanged: (value) async{
                        countries= await getCountriesFromAdress(street.text);
                        setState(() {
                          countries = countries;
                        });
                        print(countries.length);
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
                          if(spot != null){
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => AddReview(spot),
                              ),
                            );
                          }else{
                            UITemplates.showErrorMessage(context, "Please, try again");
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
                              await fillWithCurrentLocation();
                              Spot? spot = await saveSpot();
                              if(spot != null){
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => AddReview(spot),
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

  Future<bool> fillWithCurrentLocation()async{
    Location loc = Location(latitude: 0, longitude: 0, timestamp: DateTime.now());

    Placemark? placemark = await LocationServices.getAdressOfCurrentLocation(loc);


    if(placemark == null){
      return false;
    }
    print("here");
    print(placemark!.name??"not found");
    street.text = placemark!.street??"";
    location = loc;

    return true;
  }

  Future<Spot?> saveSpot()async{
    if(location== null) return null;
    Spot spot = Spot(widget.name, 0, 0, street.text, widget.description, widget.type);
    spot.lat = location!.latitude;
    spot.long = location!.longitude;
    if(await SpotFunctions.saveSpot(spot)){
      return spot;
    }
    return null;
  }

  Future<Spot?> saveSpotFromList()async{
    Spot spot = Spot(widget.name, 0, 0, street.text, widget.description, widget.type);
    spot.lat = location!.latitude;
    spot.long = location!.longitude;
    if(await SpotFunctions.saveSpot(spot)){
      return spot;
    }
    return null;
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
