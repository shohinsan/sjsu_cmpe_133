import 'dart:io';

import 'package:driver/models/user_ride_request_information.dart';
import 'package:driver/push_notifications/notification_dialog_box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../global/global.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {
    //1. Terminated
    //When the app is completely closed and opened directly from the push notification
     FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //display ride request information - user information who request a ride
        readUserRideRequestInformation(
            remoteMessage.data["rideRequestId"], context);
        print("This is Ride Request Id :: ${remoteMessage.data["rideRequestId"]}");

      }
    });

    //2. Foreground
    //When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      //display ride request information - user information who request a ride
      readUserRideRequestInformation(
          remoteMessage!.data["rideRequestId"], context);
      print("This is Ride Request Id :: ${remoteMessage.data["rideRequestId"]}");

    });

    //3. Background
    //When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      //display ride request information - user information who request a ride
      readUserRideRequestInformation(
          remoteMessage!.data["rideRequestId"], context);
      print("This is Ride Request Id :: ${remoteMessage.data["rideRequestId"]}");

    });
  }

  readUserRideRequestInformation(
      String userRideRequestId, BuildContext context) {

        FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(userRideRequestId)
        .once()
        .then((snapData) {

      if (snapData.snapshot.value != null) {
        // audioPlayer.open(Audio("sound/sound_notification.mp3"));
        // audioPlayer.play();


        double originLat = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["latitude"]);
        double originLng = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["longitude"]);
        String originAddress =
            (snapData.snapshot.value! as Map)["originAddress"];

        double destinationLat = double.parse(
            (snapData.snapshot.value! as Map)["destination"]["latitude"]);
        double destinationLng = double.parse(
            (snapData.snapshot.value! as Map)["destination"]["longitude"]);
        String destinationAddress =
            (snapData.snapshot.value! as Map)["destinationAddress"];

        String userName = (snapData.snapshot.value! as Map)["userName"]??"Saim";    // (snapData.snapshot.value! as Map)["userName"]??"Saim";
        String userPhone = (snapData.snapshot.value! as Map)["userPhone"]??"+14082041234";

        String? rideRequestId = snapData.snapshot.key;

         UserRideRequestInformation userRideRequestDetails =
            UserRideRequestInformation();
        userRideRequestDetails.originLatLng = LatLng(originLat, originLng);
        userRideRequestDetails.originAddress = originAddress;

        userRideRequestDetails.destinationLatLng =
            LatLng(destinationLat, destinationLng);
        userRideRequestDetails.destinationAddress = destinationAddress;

        userRideRequestDetails.userName = userName;
        userRideRequestDetails.userPhone = userPhone;

        print("This is user Ride Request Information :: ");
        print(userRideRequestDetails.userName);
        print(userRideRequestDetails.userPhone);
        print(userRideRequestDetails.originAddress);
        print(userRideRequestDetails.destinationAddress);


        userRideRequestDetails.rideRequestId = rideRequestId;

        showDialog(
          context: context,
          builder: (BuildContext context) => NotificationDialogBox(
            userRideRequestDetails: userRideRequestDetails,
          ),
        );

      } else {
        Fluttertoast.showToast(msg: "This Ride Request Id do not exists.");
      }
    });
  }

  Future generateAndGetToken() async {
    String? registrationToken = await messaging.getToken();
    print("FCM Registration Token: ");
    print(registrationToken);

    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("token")
        .set(registrationToken);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }
}
