import 'package:donde/BackendFunctions/Linking.dart';
import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/UI/ReviewFlow/DoesSpotExistView.dart';
import 'package:donde/UI/CreateSpot/NewSpot.dart';
import 'package:donde/UI/MainViews/MapView.dart';
import 'package:donde/UI/MainViews/SpotView.dart';
import 'package:donde/UI/Settings/LocationDialog.dart';
import 'package:donde/UI/Settings/SettingsMain.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
import 'package:flutter/services.dart';
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
    super.initState();
    spots = getSpots(200, false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            title: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 40),
              child:  Image.asset('assets/donde.png', width: MediaQuery.of(context).size.width*.4),
            ),
            actions: [
              Container(
                padding: EdgeInsets.only(right: 4, bottom: 4),
                width: 120,
                height: 120,
                child: const TabBar(
                  padding: EdgeInsets.zero,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Icon(Icons.list),
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Icon(Icons.map),
                    )
                  ],
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.black),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  TabBarView(children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        await getSpots(50, true);
                      },
                      color: Colors.white,
                      backgroundColor: Colors.black,
                      child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: spotList.length + 1,
                              key: builderKey,
                              itemBuilder: (context, index) {
                                if (index == spotList.length) {
                                  if(spotList.isEmpty){
                                    return Center(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(30.0),
                                            child: Icon(
                                              Icons.group,
                                              size: 50,
                                            ),
                                          ),
                                          Text(
                                            "No Results found",
                                            style: UITemplates.buttonTextStyle,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "add friends or create reviews",
                                            style: UITemplates.clickableText,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    height: 200,
                                  );
                                }

                                Spot spot = spotList[index];
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: SpotView(spot));
                              },
                            ),
                    ),
                    MapView(spotList, getSpots, builderKey),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Spot>> getSpots(double radius, bool refresh) async {
    if (spotList.isEmpty || refresh) {
      List<Spot> temp = await SpotFunctions.getSpots(
          Store.getListViewLocation()!.longitude.toString(),
          Store.getListViewLocation()!.latitude.toString(),
          radius);
      setState(() {
        spotList = temp;
      });
    }
    HapticFeedback.heavyImpact();
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

/*
AppBar(
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
 */
