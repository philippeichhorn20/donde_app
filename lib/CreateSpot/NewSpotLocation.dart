import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/Spot.dart';
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
  TextEditingController city = TextEditingController();
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
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width*.8,
                child: TextField(
                  autofocus: true,

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
                ),
              ),
              SizedBox(height: 30,),
              Container(
                width: MediaQuery.of(context).size.width*.8,
                child: TextField(
                  controller: city,
                  decoration:InputDecoration(
                    fillColor: Colors.white12,
                    hintText: "City",
                    hintStyle: UITemplates.descriptionStyle,
                    focusedBorder: UITemplates.appBarInputBorder,
                    filled: true,
                    border: UITemplates.appBarInputBorder,
                    enabledBorder: UITemplates.appBarInputBorder,
                  ),
                  onSubmitted: (value) async{
               countries= await getCountriesFromAdress(street.text+", "+city.text);
               print(countries.length);
                  },
                ),

              ),
              TextButton(onPressed: () async{
                await fillWithCurrentLocation();
              }, child: Text("fill")),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  MapEntry<Placemark,Location> country = countries.entries.elementAt(index);
                  return ListTile(
                    onTap: () {
                      setState(() {
                        location = country.value;
                      });
                    },
                    title: Text(country.key.country!),
                    subtitle:  Text(country.key.locality!),
                    tileColor: country.value != location?Colors.white12:Colors.grey,);
                },
              ),
              TextButton(

                  onPressed: () async{
                    Spot? spot = await saveSpot();
                if(spot != null){
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (context) => SpotView(spot!),
                    ),
                  );
                }
              }, child: Text("save")),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> fillWithCurrentLocation()async{
    Placemark? placemark = await LocationServices.getAdressOfCurrentLocation();
    print("here");

    if(placemark == null){
      return false;
    }
    print("here");
    print(placemark!.name??"not found");
    city.text = placemark!.locality??"";
    street.text = placemark!.street??"";
    return true;
  }

  Future<Spot?> saveSpot()async{
    Spot spot = Spot(widget.name, 0, 0, street.text+", "+city.text, widget.description, widget.type);
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
