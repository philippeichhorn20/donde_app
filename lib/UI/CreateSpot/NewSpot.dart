import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/UI/CreateSpot/NewSpotLocation.dart';
import 'package:donde/UI/MainViews/SpotView.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  int spotTypeIndex = 0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameControl.text = widget.name;
  }

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  autofocus: true,
                  cursorColor: Colors.black,

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
              SizedBox(height: 300,),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width*.8,
                child: TextButton(
                  style: UITemplates.buttonStyle,

                  onPressed: () async{
                    if(nameControl.text.isEmpty || nameControl.text == ""){
                      UITemplates.showErrorMessage(context, "Add a name");
                    }else{
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => NewSpotLocation(nameControl.text,descriptionControl.text,SpotTypes.values[spotTypeIndex], widget.review),
                        ),
                      );
                    }

                },child: Text("next", style: UITemplates.buttonTextStyle),),
              )
            ],
          ),
        ),
      ),
    );
  }




}
