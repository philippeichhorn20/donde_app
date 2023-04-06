import 'dart:ffi';

import 'package:donde/Classes/Spot.dart';
import 'package:donde/Store.dart';

class SpotFunctions{


  static Future<List<Spot>> getSpots(String long, String lat, double radius)async{
    print("h45454545ere");

    var res = await Store.supabase.rpc('getspots',params: {
      "lat":double.tryParse(lat),
      "long":double.tryParse(long),
      "rad": radius
    });
    print("here");
    List<Spot> spots = [];
    res.forEach((element) {
      spots.add(Spot.fromMap(element));
    });
    print(spots.length);
    return spots;
  }

  static Future<List<Spot>> fulltextspotsearch(String str)async{
    var res = await Store.supabase.rpc('fulltextspotsearch',params: {
      "str":str
    });

    List<Spot> spots = [];
    res.forEach((element) {
      spots.add(Spot.fromMap(element));
    });
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

  static Future<Spot> getspotfromid(String id)async{
    var res = await Store.supabase.rpc('getspotfromid',params: {
      "id":int.tryParse(id)
    });

    List<Spot> spots = [];
    res.forEach((element) {
      spots.add(Spot.fromMap(element));
    });
    return spots.first;
  }

}