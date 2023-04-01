import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/CreateSpot/NewSpotLocation.dart';
import 'package:donde/MainViews/SpotView.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geocoding/geocoding.dart';

class NewSpot extends StatefulWidget {
  @override
  _NewSpotState createState() => _NewSpotState();
}

class _NewSpotState extends State<NewSpot> {
  TextEditingController nameControl = TextEditingController();
  TextEditingController descriptionControl = TextEditingController();

  int spotTypeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          bottomOpacity: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: nameControl,
                decoration:InputDecoration(
                  fillColor: Colors.white12,
                  hintText: "Name",

                  hintStyle: UITemplates.descriptionStyle,
                  focusedBorder: UITemplates.appBarInputBorder,
                  filled: true,
                  border: UITemplates.appBarInputBorder,
                  enabledBorder: UITemplates.appBarInputBorder,

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: descriptionControl,

                inputFormatters: [
                  FilteringTextInputFormatter.deny("\n")
                ],
                decoration: InputDecoration(
                    hintText: "Description",

                  hintStyle: UITemplates.descriptionStyle,
                  focusedBorder: UITemplates.appBarInputBorder,
                  filled: true,
                  border: UITemplates.appBarInputBorder,
                  enabledBorder: UITemplates.appBarInputBorder,
                ),
                maxLines: 3,
                minLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                  children: List<Widget>.generate(
                    SpotTypes.values.length,
                        (index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ChoiceChip(label: Text(SpotTypes.values[index].name), selected:index == spotTypeIndex, onSelected: ((value) {
                          setState(() {
                            spotTypeIndex = index;
                          });
                        }),
                          selectedColor: Colors.black45,
                          backgroundColor: Colors.white12,
                        ),
                      );
                    },
                  )
              ),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width*.8,
              child: TextButton(
                style: UITemplates.buttonStyle,

                onPressed: () async{
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => NewSpotLocation(nameControl.text,descriptionControl.text,SpotTypes.values[spotTypeIndex]),
                    ),
                  );
              },child: Text("next", style: UITemplates.buttonTextStyle),),
            )
          ],
        ),
      ),
    );
  }




}
