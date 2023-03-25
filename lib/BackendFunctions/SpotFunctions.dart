import 'package:donde/Classes/MyUser.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/Store.dart';

class SpotFunctions{




  static Future<List<Spot>> getSpots(String long, String lat, int radius)async{
    var res = await Store.supabase.rpc('getspots',);
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
          'long': spot.long,
          'lat': spot.lat,
          'description': spot.description,
          'type': spot.type.index
        });
    spot.id = res;
    print(spot.id);
    print("here");
    return true;
  }



/*
  static Future<List<Spot>> spotsNearby()async{
    return
  }
 */
}