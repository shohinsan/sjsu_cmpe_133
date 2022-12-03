import 'package:driver/helper/helper_methods.dart';
import 'package:driver/models/user_ride_request_information.dart';
import 'package:driver/screens/home_tab.dart';
import 'package:driver/splash/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../global/global.dart';
import '../models/user_ride_request_information.dart';
import '../screens/new_trip_screen.dart';

class NotificationDialogBox extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xF2F2F9F9),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 14,
            ),

            Image.asset(
              "images/car_logo.png",
              width: 160,
            ),

            const SizedBox(
              height: 10,
            ),

            //title
            const Text(
              "New Ride Request",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black),
            ),

            const SizedBox(height: 14.0),

            const Divider(
              height: 3,
              thickness: 3,
            ),

            //addresses origin destination
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Origin Location
                  Row(
                    children: [
                      Image.asset(
                        "images/origin.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Text(
                          widget.userRideRequestDetails!.originAddress!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0),

                  // Destination Location
                  Row(
                    children: [
                      Image.asset(
                        "images/destination.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Text(
                          widget.userRideRequestDetails!.destinationAddress!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(
              height: 3,
              thickness: 3,
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: () {
                      // audioPlayer.pause();
                      // audioPlayer.stop();
                      // audioPlayer = AssetsAudioPlayer();

                      // Cancel Ride Request
                      FirebaseDatabase.instance
                          .ref()
                          .child("All Ride Requests")
                          .child(widget.userRideRequestDetails!.rideRequestId!)
                          .remove()
                          .then((value) {
                        FirebaseDatabase.instance
                            .ref()
                            .child("drivers")
                            .child(currentFirebaseUser!.uid)
                            .child("newRideStatus")
                            .set("idle");
                      }).then((value) {
                        FirebaseDatabase.instance
                            .ref()
                            .child("drivers")
                            .child(currentFirebaseUser!.uid)
                            .child("tripsHistory")
                            .child(
                                widget.userRideRequestDetails!.rideRequestId!)
                            .remove();
                      }).then((value) {
                        Fluttertoast.showToast(
                            msg:
                                "Ride Request has been Cancelled, Successfully. We're sorry to see you go");
                      });

                      Future.delayed(const Duration(milliseconds: 3000), () {
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
                      });
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 25.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: () {
                      // audioPlayer.pause();
                      // audioPlayer.stop();
                      // audioPlayer = AssetsAudioPlayer();

                      //accept the rideRequest

                      acceptRideRequest(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  acceptRideRequest(BuildContext context) {
    String getRideRequestId = "";
     FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        getRideRequestId = snap.snapshot.value.toString();

        print("Ride Request ID::");
        print(getRideRequestId);

      } else {
        Fluttertoast.showToast(msg: "This ride request do not exists.");
      }
      print("UserRideRequestDetails:");
      print(widget.userRideRequestDetails!.rideRequestId.toString());
      Fluttertoast.showToast(msg: "userRideRequestDetails!.rideRequestId= "+ widget.userRideRequestDetails!.rideRequestId.toString());

      if (getRideRequestId == widget.userRideRequestDetails!.rideRequestId) {
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid)
            .child("newRideStatus")
            .set("accepted");

        HelperMethods.pauseLiveLocationUpdates();

        //trip started now - send driver to new tripScreen
        Navigator.push(context, MaterialPageRoute(builder: (c) => NewTripScreen(
                      userRideRequestDetails: widget.userRideRequestDetails,
                    )));
      } else {
        Fluttertoast.showToast(msg: "This Ride Request do not exists.");
      }
    });
  }
}
