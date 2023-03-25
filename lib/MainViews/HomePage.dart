import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/CreateItems/NewSpot.dart';
import 'package:donde/MainViews/SpotView.dart';
import 'package:donde/Settings/SettingsMain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:donde/BasicUIElements/ListTiles.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: TextButton.icon(onPressed: (){

                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => SettingsMain(),
                  ),
                );

          }, icon: Icon(Icons.settings), label: SizedBox()),
          title: Container(
            width: MediaQuery.of(context).size.width*0.7,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Your location"
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => NewSpot(),
              ),

            );

          },
          child: Icon(Icons.add),
        ),
        body: FutureBuilder(
            future: getSpots(),
            builder: (context, snapshot) {
              if(snapshot == null || snapshot.data == null || snapshot.data!.length ==0){
                return SizedBox();
              }
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Spot spot = snapshot.data![index];
                  return Container(
                      height: MediaQuery.of(context).size.height*.7,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SpotView(spot),
                      ));
                },
              );
            },),
      ),
    );
  }

  Future<List<Spot>> getSpots()async{
    return await SpotFunctions.getSpots("", "", 4);
  }
}
