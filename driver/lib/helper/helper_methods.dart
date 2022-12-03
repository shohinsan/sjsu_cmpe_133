import 'package:driver/helper/request_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

import '../global/global.dart';
import '../global/map_key.dart';
import '../info_handler/app_info.dart';
import '../models/direction_details_info.dart';
import '../models/directions.dart';
import '../models/trips_history_model.dart';
import '../models/user_model.dart';

class HelperMethods {
  static Future<String> searchAddressForGeographicCoOrdinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestHelper.receiveRequest(apiUrl);

    if (requestResponse != "Error Occurred, Failed. No Response.") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestHelper.receiveRequest(
        urlOriginToDestinationDirectionDetails);

    if (responseDirectionApi == "Error Occurred, Failed. No Response.") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static pauseLiveLocationUpdates() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

  static resumeLiveLocationUpdates() {
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
  }

  // static double calculateFareAmountFromOriginToDestination(
  //     DirectionDetailsInfo directionDetailsInfo) {
  //   double timeTraveledFareAmountPerMinute =
  //       (directionDetailsInfo.duration_value! / 60) * 0.1;
  //   double distanceTraveledFareAmountPerMile =                          //KM-->Mile 1000-->5260
  //       (directionDetailsInfo.duration_value! / 5280) * 0.1;
  //
  //   //USD
  //   double totalFareAmount = timeTraveledFareAmountPerMinute +
  //       distanceTraveledFareAmountPerMile;                        //mile
  //
  //   // if (driverVehicleType == "Car") {
  //   //    totalFareAmount = (totalFareAmount.toStringAsFix()) / 2.0;
  //   //   return totalFareAmount;
  //   // // } else if (driverVehicleType == "Minivan") {
  //   // //   return totalFareAmount.truncate().toDouble();
  //   // // } else if (driverVehicleType == "Minibus") {
  //   // //   double resultFareAmount = (totalFareAmount.truncate()) * 2.0;
  //   // //   return resultFareAmount;
  //   // } else {
  //
  //     return double.parse(totalFareAmount.toStringAsFixed(2));
  //
  // }

  // static double calculateFareAmountFromOriginToDestination(
  //     DirectionDetailsInfo directionDetailsInfo) {
  //   double timeTraveledFareAmountPerMinute =
  //       (directionDetailsInfo.duration_value! / 60) * 0.1; // $.1 per minute
  //   double distanceTraveledFareAmountPerMile =
  //       (directionDetailsInfo.duration_value! / 5280) *
  //           0.1; // $.1 per mile distance_-->duration
  //
  //   //USD
  //   double totalFareAmount =
  //       timeTraveledFareAmountPerMinute + distanceTraveledFareAmountPerMile;
  //
  //   return double.parse(totalFareAmount.toStringAsFixed(2)); //round two two digits ex: 23.234= 23.23
  // }

  static double calculateFareAmountFromOriginToDestination(
      DirectionDetailsInfo directionDetailsInfo) {
    double timeTraveledFareAmountPerMinute =
        (directionDetailsInfo.duration_value! / 60) * 0.1;
    double distanceTraveledFareAmountPerMile =
        (directionDetailsInfo.duration_value! / 5280) * 0.1;

    //USD
    double totalFareAmount =
        timeTraveledFareAmountPerMinute + distanceTraveledFareAmountPerMile;

    if (driverVehicleType == "Car") {
      double resultFareAmount = (totalFareAmount.truncate()) / 2.0;
      return resultFareAmount;
    } else if (driverVehicleType == "Minivan") {
      return totalFareAmount.truncate().toDouble();
    } else if (driverVehicleType == "Minibus") {
      double resultFareAmount = (totalFareAmount.truncate()) * 2.0;
      return resultFareAmount;
    } else {
      return totalFareAmount.truncate().toDouble();
    }
  }

  //retrieve the trips KEYS for online user
  //trip key = ride request key

  static void readTripsKeysForOnlineDriver(context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .orderByChild("driverId")
        .equalTo(fAuth.currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        Map keysTripsId = snap.snapshot.value as Map;

//count total number trips and share it with Provider
        int overAllTripsCounter = keysTripsId.length;
        Provider.of<AppInfo>(context, listen: false)
            .updateOverAllTripsCounter(overAllTripsCounter);

//share trips keys with Provider
        List<String> tripsKeysList = [];
        keysTripsId.forEach((key, value) {
          tripsKeysList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false)
            .updateOverAllTripsKeys(tripsKeysList);

//get trips keys data - read trips complete information
        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context) {
    var tripsAllKeys =
        Provider.of<AppInfo>(context, listen: false).historyTripsKeysList;

    for (String eachKey in tripsAllKeys) {
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Requests")
          .child(eachKey)
          .once()
          .then((snap) {
        var eachTripHistory = TripsHistoryModel.fromSnapshot(snap.snapshot);

        if ((snap.snapshot.value as Map)["status"] == "ended") {
//update-add each history to OverAllTrips History Data List
          Provider.of<AppInfo>(context, listen: false)
                  .updateOverAllTripsHistoryInformation(eachTripHistory) /
              2.0;
        }
      });
    }
  }

//readDriverEarnings

  static void readDriverEarnings(context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("earnings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String driverEarnings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false)
            .updateDriverTotalEarnings(driverEarnings);
      }
    });

    readTripsKeysForOnlineDriver(context);
  }
}
