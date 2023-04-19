import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class LocationDialog {

  static TextEditingController text = TextEditingController();

  static Location? myLoc;


  static Widget getLocationDialog(BuildContext context){

    return StatefulBuilder(
      builder: (context, getState) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
          if(myLoc== null)
         SizedBox(height: 300,),

        if(myLoc!=null)
        Container(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            //    Transform.rotate(angle: LocationServices.getDirection(location!),child: Icon(Icons.arrow_forward, size: 120,),),
            //    SizedBox(height: 50,),
             //   Text(LocationServices.getDistance(location!).toString(), style: UITemplates.importantTextStyle,),
              ],
            ),
          ),
        ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*.6,
                  child: TextField(
                    autofocus: true,
                    cursorColor: Colors.black,

                    controller: text,
                    style: UITemplates.importantTextStyle,
                    decoration: InputDecoration(
                      hintText: "Adress",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onSubmitted: (value) async{
                  //    location = await getLocFromStr(value, location);
                      getState(() {
                   //     myLoc = location;

                        myLoc = myLoc;
                      },);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  static Future<Location> getLocFromStr(String str, Location? location1)async{
    return (await LocationServices.getLocationsFromString(str)).first;
  }
}
