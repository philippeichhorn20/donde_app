import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/BasicUIElements/ListTiles.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/CreateSpot/NewSpot.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DoesSpotExist extends StatefulWidget {
  @override
  _DoesSpotExistState createState() => _DoesSpotExistState();
}

class _DoesSpotExistState extends State<DoesSpotExist> {
  TextEditingController searchText = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: TextField(
            controller: searchText,
            cursorColor: Colors.black,
            style: UITemplates.descriptionStyle,
autofocus: true,
            decoration: InputDecoration(
              fillColor: Colors.white12,
              hintText: "search all spots",
              hintStyle: UITemplates.descriptionStyle,
              focusedBorder: UITemplates.appBarInputBorder,
              filled: true,
              border: UITemplates.appBarInputBorder,
              enabledBorder: UITemplates.appBarInputBorder,

            ),
            onSubmitted: (text){
              setState(() {
                searchText;
              });
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:10.0, left: 10,right: 10),
              child: ListTile(
                onTap: (){
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => NewSpot(),
                    ),
                  );
                },
                title: Text("Add a new location", style: UITemplates.buttonTextStyle,),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                tileColor: Colors.grey[900],
              ),
            ),


            FutureBuilder(
              future: SpotFunctions.fulltextspotsearch(searchText.text),
                builder: (context, snapshot){
                  if(snapshot == null || snapshot.data == null || snapshot.data!.length ==0){
                    print("n0othing");
                    return SizedBox();
                  }
                  print(snapshot.data!.length.toString());

                  return Container(
                    child: Flexible(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot == null||snapshot.data == null?0:snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Spot spot = snapshot.data![index];
                          return ListTiles.spotListTile(spot, context);
                        },
                      ),
                    ),
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
