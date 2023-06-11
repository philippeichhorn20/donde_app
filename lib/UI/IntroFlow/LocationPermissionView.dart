import 'package:donde/Store.dart';
import 'package:donde/UI/MainViews/Skeleton.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionView extends StatefulWidget {
  const LocationPermissionView({Key? key}) : super(key: key);

  @override
  State<LocationPermissionView> createState() => _LocationPermissionViewState();
}

class _LocationPermissionViewState extends State<LocationPermissionView> {
  bool permissionDenied = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestLocPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 100,),

            Text("Location access needed", style: UITemplates.buttonTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15,),
            Container(
              width: 400,
              child: Text("This app can only be used when the location access is permitted", style: UITemplates.clickableText,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Icon(Icons.location_on_outlined, size: 50,),
            ),
            if(permissionDenied)
            Container(
              margin: const EdgeInsets.all(20.0),
              child: TextButton(
                style:  TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  foregroundColor: Colors.transparent,
                ),
                onPressed: ()async {
                  await Geolocator.openAppSettings();
                },
                child: Text("Open Settings", style: UITemplates.importantTextStyle,),
              ),
            ),

            Container(
              margin: const EdgeInsets.all(20.0),
              child: TextButton(
                style:  TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  foregroundColor: Colors.transparent,
                ),
                onPressed: ()async {
                  await requestLocPermission();
                },
                child: Text("Check again", style: UITemplates.importantTextStyleHint,),
              ),
            )

          ],
        ),
      ),
    );
  }


  Future<void> requestLocPermission()async{
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      serviceEnabled = false;
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        serviceEnabled = false;
      }
    }
    if(permission == LocationPermission.always || permission == LocationPermission.whileInUse){
      serviceEnabled = true;
    }else{
      serviceEnabled = false;
    }
    if(serviceEnabled){
      await Store.initLoc();
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => Skeleton(),
        ),
      );
    setState(() {
      permissionDenied = false;
    });

    }
    setState(() {
      permissionDenied = true;
    });


  }


}
