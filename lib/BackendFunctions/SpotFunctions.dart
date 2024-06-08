import 'dart:ffi';

import 'package:donde/Classes/RawSpot.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/Store.dart';

class SpotFunctions{


  static Future<List<Spot>> getSpots(String long, String lat, double radius)async{

    var res = await Store.supabase.rpc('getspots',params: {
      "lat":double.tryParse(lat),
      "long":double.tryParse(long),
      "rad": radius
    });
    List<Spot> spots = [];
    res.forEach((element) {
      spots.add(Spot.fromMap(element));
    });

    print("getspot ${spots.length}");
    return spots;
  }

  static Future<List<RawSpot>> fulltextspotsearch(String str)async{
    str = str.replaceAll(RegExp("[^A-Za-z0-9]"),"");
    //str = str.replaceAll(" ","|");
    var res;
    if(str != "") {
      try{
        res = await Store.supabase.rpc('fulltextspotsearch', params: {
          "str": str
        });
      }catch(e){
      }
    }else{
      return [];
    }

    List<RawSpot> spots = [];
    res.forEach((element) {
      spots.add(Spot.fromMap(element));
    });
    print("fulltextspotsearch ${spots.length}");

    return spots;
  }

  static Future<List<RawSpot>> getallspotsnearyou(double lat,long)async{
    var res = await Store.supabase.rpc('getallspotsnearyou',params: {
      "lat":lat,
      "long":long
    });

    List<RawSpot> spots = [];
    res.forEach((element) {
      spots.add(Spot.fromMap(element));
    });
    print("getallspotsnearyou ${spots.length}");
    return spots;
  }

  static Future<bool> saveSpot(Spot spot)async{
    int res = await Store.supabase.rpc('savespot',
        params: {
          'name': spot.name,
          'adress': spot.adress,
          'description': spot.description,
          'type': spot.type.index,
          'latlong': "POINT(${spot.lat} ${spot.long})"
        });

    spot.id = res;
    print("ress");
    print(res);

    return true;
  }

  static Future<Spot?> getspotfromid(String id)async{
    if(id != ""){
      var res = await Store.supabase.rpc('getspotfromid',params: {
        "id":int.tryParse(id)
      });



    if(res.length == 0){
      return null;
    }
    List<Spot> spots = [];
    res.forEach((element) {
      spots.add(Spot.fromMap(element));
    });
    print("getspotfromid ${spots.length}");
    return spots.first;
    }
  }
}