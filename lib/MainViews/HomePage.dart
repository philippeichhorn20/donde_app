import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/CreateSpot/DoesSpotExistView.dart';
import 'package:donde/CreateSpot/NewSpot.dart';
import 'package:donde/MainViews/MapView.dart';
import 'package:donde/MainViews/SpotView.dart';
import 'package:donde/Settings/LocationDialog.dart';
import 'package:donde/Settings/SettingsMain.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:donde/BasicUIElements/ListTiles.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future spots;
  List<Spot> spotList = [];
  GlobalKey builderKey = GlobalKey();


  initState() {
    print("inniting homepage");
    super.initState();
    spots = getSpots(200, false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
            leading: Container(
              child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => SettingsMain(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white38,
                    size: 32,
                  ),
                  label: SizedBox()),
            ),
            title: TextButton(
              onPressed: () async {
             //   print("pressed");
            //   await buildLocationDialog(context);
             //   await forceNewSpots(30, setState);
           //     setState(() {
           //       spotList = spotList;
           //     });
              },
              child: Text(
                "donde.",
                style: UITemplates.smallTitleStyle,
              ),
            )),
        body: Stack(
          children: [
            DefaultTabController(

            length: 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                TabBarView(
                    children: [
                  RefreshIndicator(
                    onRefresh: ()async{
                      await getSpots(50, true);
                    },
                    color: Colors.white,
                    backgroundColor: Colors.black,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: spotList.length+1,
                      key: builderKey,
                      itemBuilder: (context, index) {
                        if(index == spotList.length){
                          return Padding(
                            padding: const EdgeInsets.only(top:20.0,bottom:100.0,left:20.0,right:20.0,),
                            child: TextButton(
                              child: Text("Add a new location", style: UITemplates.buttonTextStyle,),
                              style: UITemplates.lightButtonStyle,

                              onPressed: (){
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => DoesSpotExist(),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        Spot spot = spotList[index];
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SpotView(spot),
                            ));
                      },
                    ),
                  ),
                  MapView(spotList, getSpots, builderKey),
                ]),
                Positioned(
                  bottom: 40,
                  child: Container(
                    width: 150,

                    decoration: BoxDecoration(

                        borderRadius:
                        BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey
                    ),

                    child: Container(
                      child: const TabBar(

                        tabs: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.list),
                          ),

                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.map),
                          )],
                        indicator:  BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20)),
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Future<List<Spot>> getSpots(double radius, bool refresh) async {
    if(spotList.isEmpty || refresh){
      print("loading new spotlist");
      List<Spot> temp = await SpotFunctions.getSpots(Store.getListViewLocation()!.longitude.toString(), Store.getListViewLocation()!.latitude.toString(), radius);
      setState((){
        spotList = temp;
      });
    }
    return spotList;
  }



  Future<Widget?> buildLocationDialog(BuildContext context) {
    return showGeneralDialog<Widget>(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return LocationDialog.getLocationDialog(context);
        });
  }
}
