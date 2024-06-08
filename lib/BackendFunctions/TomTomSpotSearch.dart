import 'dart:convert';

import 'package:donde/Classes/RawSpot.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/Store.dart';
import 'package:http/http.dart' as http;

class TomTomSpotSearch{

  static Future<List<RawSpot>> getSpots(bool isTypeahead, String str)async{
    http.Response res;
    List<RawSpot> rawSpots = [];
    print("tomotom str: $str");
    if(Store.position != null){
      res = await http.get(Uri.parse('https://api.tomtom.com/search/2/search/${str.replaceAll(",", "")}.json?key=o7X1TMj8PItkkp5UNWq1riNorPVGrrZC&typeahead=${isTypeahead}&lat=${Store.position!.latitude}&lon=${Store.position!.longitude}'));
    }else{
      res = await http.get(Uri.parse('https://api.tomtom.com/search/2/search/${str.replaceAll(",", "")}.json?key=o7X1TMj8PItkkp5UNWq1riNorPVGrrZC&typeahead=${isTypeahead}'));
    }
    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> resMap = json.decode(res.body);
      List<dynamic> resultList = resMap.remove("results");
       rawSpots = [];
      resultList.forEach((element) {
        print(element.toString());
        RawSpot spot = RawSpot.fromMap(element);
        print(spot.toString());
        rawSpots.add(spot);
      });
      print(rawSpots.length);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
    }
    return rawSpots;
  }



  //Apple Maps Alternative

  static Future<List<RawSpot>> getSpotsAppleMaps(bool isTypeahead, String str)async{
    http.Response res;
    List<RawSpot> rawSpots = [];
    print("apple maps str: $str");
    if(Store.position != null){
      res = await http.get(Uri.parse('https://maps-api.apple.com/v1/searchAutocomplete?q=$str'));
    }else{
      res = await http.get(Uri.parse('https://maps-api.apple.com/v1/searchAutocomplete?q=$str&searchLocation=${Store.position!.latitude},${Store.position!.longitude}'));
    }
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      Map<String,dynamic> resMap = json.decode(res.body);
      print(resMap);
      List<dynamic> resultList = resMap.remove("results");
      rawSpots = [];
      resultList.forEach((element) {
        RawSpot? spot = RawSpot.fromAppleMap(element);
        if(spot != null){
          rawSpots.add(spot);
        }
      });
      print(rawSpots.length);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
    }
    return rawSpots;
  }
}