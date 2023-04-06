import 'dart:math';
import 'dart:ui';

import 'package:donde/Classes/Spot.dart';
import 'package:donde/MainViews/SpotView.dart';
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

class _MapViewState extends State<MapView> {
  final _mapController = MapController();
  GlobalKey key = GlobalKey();

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use `MapController` as needed
    });
    FirebaseAnalytics.instance.logEvent(name: "map_view");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,

            options: MapOptions(
                center: LatLng(Store.getListViewLocation()!.latitude,Store.getListViewLocation()!.longitude),
                zoom: 7.0,
                maxZoom: 19.0,
                interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,

                maxBounds: LatLngBounds(
                  LatLng(-90, -180.0),
                  LatLng(90.0, 180.0),
                ),

            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayerOptions(
                key: key,
                markers: widget.spotList.map((e) => Marker(point: LatLng(e.lat??0,e.long??0),
                  width: 40,
                  height: 40,
                  builder: (context) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    ),
                      padding: EdgeInsets.zero
                    ),
                    onPressed: () {
                      showDialog(context: context, builder: (context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(left:10.0,right: 10, top: 50,bottom: 40),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))

                                ),
                                child: SingleChildScrollView(child: SpotView(e))),
                          ),
                        );
                      },);
                    },

                    child: Container(
                        child:
                    Icon(Icons.restaurant_menu,color: Colors.white,size: 25,)),

                  );
                },)).toList()
              ),

            ],

          ),
          Positioned(
              bottom: 100,
              right: 40,
              child: ElevatedButton(
                style: UITemplates.mapButtonStyle,
            onPressed: () async{
              Store.listViewLocation = Location(latitude: _mapController.center.latitude, longitude: _mapController.center.longitude, timestamp: DateTime.now());

              await widget.forceNewSpots(((40000/pow(2,_mapController.zoom)) * 2).toDouble(), true);
            },
            child: Icon(Icons.refresh),

          ))
        ],
      ),
    );
  }
}
