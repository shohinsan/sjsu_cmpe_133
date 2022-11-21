import 'dart:async';

import 'package:driver/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helper/helper_methods.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Position? driverCurrentPosition;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  String statusText = "Status: Offline";
  Color statusColor = Colors.red;
  bool isDriverActive = false;

  StreamSubscription<Position>? streamSubscriptionPosition;

  lightThemedGoogleMap() {
    newGoogleMapController!.setMapStyle('''[{
              "featureType": "water",
              "elementType": "geometry",
              "stylers": [{
                "color": "#e9e9e9"
              }, {
                "lightness": 17
              }]}, {
              "featureType": "landscape",
              "elementType": "geometry",
              "stylers": [{
                "color": "#f5f5f5"
              }, {
                "lightness": 20
              }]}, {
              "featureType": "road.highway",
              "elementType": "geometry.fill",
              "stylers": [{
                "color": "#ffffff"
              }, {
                "lightness": 17
              }]}, {
              "featureType": "road.highway",
              "elementType": "geometry.stroke",
              "stylers": [{
                "color": "#ffffff"
              }, {
                "lightness": 29
              }, {
              "weight": 0.2
              }]}, {
              "featureType": "road.arterial",
              "elementType": "geometry",
              "stylers": [{
                "color": "#ffffff"
              }, {
                "lightness": 18
            }]}, {
              "featureType": "road.local",
              "elementType": "geometry",
              "stylers": [ {
                "color": "#ffffff"
            }, {
            "lightness": 16
            }]}, {
            "featureType": "poi",
            "elementType": "geometry",
            "stylers": [ {
                "color": "#f5f5f5"
            }, {
                "lightness": 21
            }]}, {
            "featureType": "poi.park",
            "elementType": "geometry",
            "stylers": [{
                "color": "#dedede"
            }, {
                "lightness": 21
            }]}, {
            "elementType": "labels.text.stroke",
            "stylers": [{
                "visibility": "on"
            }, {
                "color": "#ffffff"
            }, {
                "lightness": 16
            }]}, {
            "elementType": "labels.text.fill",
            "stylers": [{
                "saturation": 36
            }, {
                "color": "#333333"
            }, {
                "lightness": 40
            }]}, {
            "elementType": "labels.icon",
            "stylers": [{
                "visibility": "off"
            }]}, {
            "featureType": "transit",
            "elementType": "geometry",
            "stylers": [{
                "color": "#f2f2f2"
            }, {
            "lightness": 19
            }]}, {
            "featureType": "administrative",
            "elementType": "geometry.fill",
            "stylers": [{
                "color": "#fefefe"
            }, {
                "lightness": 20
            }]}, {
            "featureType": "administrative",
            "elementType": "geometry.stroke",
            "stylers": [{
                "color": "#fefefe"
            },{
                "lightness": 17
            }, {
                "weight": 1.2
            }]}]
              
              ''');
  }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateDriverPosition() async {
    Position currPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = currPosition;

    LatLng latLngPosition = LatLng(
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await HelperMethods.searchAddressForGeographicCoordinates(
            driverCurrentPosition!, context);
    print("This is your current position = $humanReadableAddress");
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;
            lightThemedGoogleMap();

            locateDriverPosition();
          },
        ),

        // UI For Online/Offline Toggle - Driver Exclusive
        statusText != "Status: Online"
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.black87,
              )
            : Container(),

        // Button For Online/Offline Toggle - Driver Exclusive

        Positioned(
          top: statusText != "Status: Online"
              ? MediaQuery.of(context).size.height * 0.4
              : 25,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),

                child: ElevatedButton(
                  onPressed: () {
                    driverIsOnline();
                    updateDriversLocationAtRealTime();

                    if (isDriverActive != true) {
                      setState(() {
                        statusText = "Status: Online";
                        statusColor = Colors.green;
                        isDriverActive = true;
                      });
                    } else {
                      driverIsOffline();
                      setState(() {
                        statusText = "Status: Offline";
                        statusColor = Colors.red;
                        isDriverActive = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(

                    primary: statusColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 100),

                  ),
                  child: statusText != "Status: Online"
                      ? Text(
                          statusText,

                          style: const TextStyle(

                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),

                        )
                      : const Icon(
                          Icons.phonelink_ring,

                          color: Colors.white,
                          size: 30,

                        ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  driverIsOnline() async {
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("drivers/${currentFirebaseUser!.uid}/newRideStatus");

    // Search For Ride Requests
    ref.set("idle");
    ref.onValue.listen((event) {});
  }

  updateDriversLocationAtRealTime() async {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;

      if (isDriverActive == true) {
        Geofire.setLocation(currentFirebaseUser!.uid,
            driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
      }

      LatLng latLngPosition = LatLng(
          driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

      newGoogleMapController!
          .animateCamera(CameraUpdate.newLatLng(latLngPosition));


    });
  }

  driverIsOffline() {
    Geofire.removeLocation(currentFirebaseUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers/${currentFirebaseUser!.uid}/newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(const Duration(seconds: 2), () {
      SystemNavigator.pop();
    });
  }
}
