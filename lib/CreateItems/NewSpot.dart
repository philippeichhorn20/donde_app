import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/MainViews/SpotView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';

class NewSpot extends StatefulWidget {
  @override
  _NewSpotState createState() => _NewSpotState();
}

class _NewSpotState extends State<NewSpot> {
  TextEditingController nameControl = TextEditingController();
  TextEditingController adressControl = TextEditingController();
  TextEditingController descriptionControl = TextEditingController();

  int spotTypeIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 100,),
            TextField(
              controller: nameControl,
              decoration:InputDecoration(
                hintText: "Name"
              ),
            ),
            Wrap(
              children: List<Widget>.generate(
                SpotTypes.values.length,
                  (index) {
                    return ChoiceChip(label: Text(SpotTypes.values[index].name), selected:index == spotTypeIndex, onSelected: ((value) {
                    setState(() {
                      spotTypeIndex = index;
                    });
                    }),
                    selectedColor: Colors.black45,
                    backgroundColor: Colors.white38,
                    );
                  },
              )
            ),
            TextField(
              controller: adressControl,
              decoration: InputDecoration(
                hintText: "Adress"
              ),
            ),
            TextField(
              controller: descriptionControl,
              decoration: InputDecoration(
                  hintText: "Adress"
              ),
            ),
            TextButton(onPressed: ()async{
              Spot spot = await saveSpot();
              print(spot.id);
              if(spot.id != null){
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => SpotView(spot),
                  ),
                );
            }
            },child: Text("save"),)
          ],
        ),
      ),
    );
  }



  Future<Spot> saveSpot()async{
    Location location = (await locationFromAddress(adressControl.text)).first;
    Spot spot = Spot(nameControl.text, 0, 0, adressControl.text, descriptionControl.text, SpotTypes.values[spotTypeIndex]);
    if(location != null && location.longitude != 0){
      spot.long = location.longitude;
      spot.lat = location.latitude;
    }
    await SpotFunctions.saveSpot(spot);
    return spot;
  }
}
