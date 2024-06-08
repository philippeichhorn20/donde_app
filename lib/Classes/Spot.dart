import 'dart:convert';

import 'package:donde/BackendFunctions/LocationServices.dart';
import 'package:donde/Classes/RawSpot.dart';
import 'package:donde/Classes/Review.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Spot extends RawSpot{
  List<Review> reviews = [];
  String name;
  int likes;
  int dislikes;
  String adress;
  String description;
  double? long;
  double? lat;
  bool isAd = false;
  SpotTypes type;
  int? id;

  Spot(this.name, this.likes, this.dislikes, this.adress, this.description,
      this.type);

  static Spot adSpot(){
    Spot spot =   Spot("", 0, 0, "", "",
        SpotTypes.Spot);
    spot.isAd = true;
    return spot;
  }

  static Spot fromMap(Map<String, dynamic> spotMap) {
    print(spotMap.toString());
    Spot spot = Spot(
        spotMap.remove("name"),
        0,
        0,
        spotMap.remove("adress"),
        spotMap.remove("description"),
        SpotTypes.values[spotMap.remove("type")]);

    spot.id = spotMap.remove("id");
    print(spot.id);
    // dislikes = spotMap.remove("name");
    //  likes = spotMap.remove("name");

    try {
      String point = spotMap.remove("latlong") ?? "1 1";
      int length = point.length;
      List<String> points = point.substring(6, length - 1).split(" ");
      spot.lat = (double.tryParse(points[0])) ?? 0;
      spot.long = (double.tryParse(points[1])) ?? 0;
    } catch (e) {
      spot.lat = 0;
      spot.long = 0;
      print(e);
    }

    spot.latlong = Location(latitude: spot.lat!, longitude: spot.long!, timestamp: DateTime.now());

    return spot;
  }

  String getAverageRating() {
    if (reviews.isEmpty) {
      print("no reviews");
      return "no revs";
    } else {
      int sum = 0;
      int ratingCount = 0;
      reviews.forEach((e) {
        sum += e.rating ?? 0;
        if (e.rating != null) {
          ratingCount++;
        }
      });
      if (ratingCount == 0) {
        print(reviews.length);
        return "no countables";
      }
      return (sum / ratingCount).toStringAsFixed(1);
    }
  }

  String getDistance() {
    print(this.adress);
    Location loc =
        Location(latitude: lat??0, longitude: long??0, timestamp: DateTime.now());
    return LocationServices.getDistance(loc);
  }

  int getDistanceNum() {
    Location loc =
    Location(latitude: lat!, longitude: long!, timestamp: DateTime.now());
    return LocationServices.getDistanceNum(loc);
  }

  IconData getIcon() {
    switch (type) {
      case SpotTypes.Restaurant:
        return Icons.restaurant;
      case SpotTypes.Bar:
        return Icons.local_bar;
        break;
      case SpotTypes.Club:
        // TODO: Handle this case.
        return Icons.nightlife;
      case SpotTypes.Stay:
        return Icons.night_shelter;
        // TODO: Handle this case.
        break;
      case SpotTypes.Spot:
        return Icons.not_listed_location;
        break;
      case SpotTypes.Culture:
        return Icons.local_activity;
        break;
      case SpotTypes.Nature:
        // TODO: Handle this case.
        return Icons.landscape;
      case SpotTypes.Other:
        return Icons.interests;
        break;
      case SpotTypes.Cafe:
        return Icons.local_cafe;
        break;
    }
  }
}

enum SpotTypes {
  Restaurant,
  Bar,
  Club,
  Stay,
  Spot,
  Culture,
  Nature,
  Other,
  Cafe
}
