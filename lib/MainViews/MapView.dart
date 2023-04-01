import 'dart:ui';

import 'package:donde/Classes/Spot.dart';
import 'package:donde/MainViews/SpotView.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  final List<Spot> spotList;
  final Location? location;
  MapView(this.spotList, this.location);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _mapController = MapController();

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use `MapController` as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
            center: widget.location == null ? LatLng(Store.position!.latitude, Store.position!.longitude):LatLng(widget.location!.latitude,widget.location!.longitude),
            zoom: 13.0,

            maxZoom: 19.0,
            controller: _mapController,
            keepAlive: false,
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            bounds: LatLngBounds(
              LatLng(51.74920, -0.56741),
              LatLng(51.25709, 0.34018),
            ),
            maxBounds: LatLngBounds(
              LatLng(-90, -180.0),
              LatLng(90.0, 180.0),
            ),

            onTap: (tapPosition, latLang) {

            }
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayerOptions(

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
                            child: SpotView(e)),
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
        children: [
        ],
        nonRotatedChildren: [],
      ),
    );
  }
}
