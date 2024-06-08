import 'package:donde/BackendFunctions/Linking.dart';
import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/UI/MainViews/FeedView.dart';
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
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  late Future spots;
  List<Spot> spotList = [];
  List<Spot> rawSpotList = [];

  late TabController tabControl;


  GlobalKey builderKey = GlobalKey();
  int spotTypeIndex = -1;
  initState() {
    super.initState();
    tabControl = TabController(length: 2, vsync: this);
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
            automaticallyImplyLeading: false,
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
                child:  TabBar(
                  padding: EdgeInsets.zero,
                  tabs: [

                    Padding(
                      padding: EdgeInsets.zero,
                      child: Icon(Icons.list),
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Icon(Icons.map),
                    ),
                  ],
                  onTap: (value) {
setState(() {
  tabControl.index = value;
});                    HapticFeedback.heavyImpact();
                  },
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.black),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(right: 40),

                children:  List<Widget>.generate(
                  SpotTypes.values.length,
                      (index) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ChoiceChip(
                        padding: EdgeInsets.zero,
                        label: Text(SpotTypes.values[index].name),
                        selected: index == spotTypeIndex,
                        onSelected: ((value) {
                          HapticFeedback.heavyImpact();
                          if(index == spotTypeIndex){
                            setState(() {
                              spotTypeIndex = -1;
                            });
                            updateTypes(-1);
                          }else{
                            updateTypes(index);

                            setState(() {
                              spotTypeIndex = index;
                            });
                          }

                        }),
                        selectedColor: Colors.black45,
                        backgroundColor: Colors.white12,
                      ),
                    );
                  },
                ),
              ),
            ),
            ),
          ),
          body: Stack(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  TabBarView(

                      controller: tabControl,
                      children: [
                        FeedView(forceNewSpots: getSpots, spotList: spotList, builderKey: builderKey),
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

  void moveToMap(Spot spot){
    setState(() {
      tabControl.index = 0;
      tabControl.animateTo(0);
    });
    Store.moveToMap(spot);
  }


  Future<List<Spot>> getSpots(double radius, bool refresh) async {
    if (spotList.isEmpty || refresh) {
      List<Spot> temp = await SpotFunctions.getSpots(
          Store.getListViewLocation()!.longitude.toString(),
          Store.getListViewLocation()!.latitude.toString(),
          radius);

        spotList = temp;
        rawSpotList = spotList;
        updateTypes(spotTypeIndex);

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

  void updateTypes(int type){
    if(type == -1){
      setState(() {
        spotList = rawSpotList;

      });
    }else{
      spotList = [];
      rawSpotList.forEach((element) {
        if(element.type.index == type){
          spotList.add(element);
        }
      });
      setState(() {
        spotList = spotList;
      });
    }
  }

}



/*
AppBar(
          elevation: 0,
            leading: Container(
              child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      CupetinoPageRoute(
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
