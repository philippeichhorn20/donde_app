import 'dart:math';
import 'dart:ui';

import 'package:donde/Classes/Spot.dart';
import 'package:donde/UI/MainViews/SpotView.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  final List<Spot> spotList;
  final Function(double, bool) forceNewSpots;
  final GlobalKey builderkey;

  MapView(this.spotList,this.forceNewSpots, this.builderkey);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with AutomaticKeepAliveClientMixin{
  final _mapController = MapController();
  GlobalKey key = GlobalKey();

  @override
  void initState(){
    super.initState();
    Store.mapController = _mapController;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use `MapController` as needed
    });
    FirebaseAnalytics.instance.logEvent(name: "map_view");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      child: Stack(
        children: [

          FlutterMap(
            mapController: _mapController,

            options: MapOptions(
                center: LatLng(Store.getListViewLocation()!.latitude,Store.getListViewLocation()!.longitude),
                zoom: 12.0,
                maxZoom: 18.0,
                interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                maxBounds: LatLngBounds(
                  LatLng(-90, -180.0),
                  LatLng(90.0, 180.0),
                ),

            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://tiles.stadiamaps.com/tiles/outdoors/{z}/{x}/{y}{r}.png?api_key={api_key}",
additionalOptions: {
  "api_key": "1f0e23ae-654e-4e3a-a48f-ff510f9b0a00",
}
),
              MarkerLayerOptions(
                key: key,

                markers: widget.spotList.map((e) => Marker(

                  point: LatLng(e.lat??0,e.long??0),
                  width: 130,
                  height:45,

                  builder: (context) {

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Colors.grey[800]!,
                      )
                    ),
                      padding: EdgeInsets.zero
                    ),
                    onPressed: () {
                      showDialog(context: context, builder: (context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(left:10.0,right: 10, top: 50,bottom: 150),
                            child: Container(
                              height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: SingleChildScrollView(child: SpotView(e, (){}))),
                          ),
                        );
                      },);
                    },

                    child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: LayoutBuilder(
                                  builder: (context, snapshot) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        FittedBox(
                                            child: Container(
                                                child: Text(e.name??"", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),maxLines: 2,)),
                                      //  fit: BoxFit.scaleDown,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,

                                          child: SizedBox(
                                              child: Text(e.type.name??"", style: TextStyle(fontSize: 10), maxLines: 2,)),
                                        ),
                                      ],
                                    );
                                  }
                                ),
                              ),
                            ),
                            Container(child:Icon(e.getIcon(), size: 20,),alignment: Alignment.centerRight,),

                          ],
                        )
                    ),

                  );
                },)).toList()
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    point: LatLng(Store.getListViewLocation()!.latitude,Store.getListViewLocation()!.longitude),
                    builder: (context) {
                      return Icon(Icons.location_on, color: Colors.grey[700],size: 50,);
                    },
                    height: 45,
                    width: 45,
                    anchorPos: AnchorPos.align(AnchorAlign.top),
                  )
                ]
              )
            ],

          ),

          Positioned(
              bottom: 100,
              right: 40,
              child: ElevatedButton(
                style: UITemplates.mapButtonStyle,
            onPressed: () async{
          //    Store.listViewLocation = Location(latitude: _mapController.center.latitude, longitude: _mapController.center.longitude, timestamp: DateTime.now());
              await widget.forceNewSpots(((40000/pow(2,_mapController.zoom)) * 2).toDouble(), true);
            },
            child: Icon(Icons.refresh),
          ))

        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
