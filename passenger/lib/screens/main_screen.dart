import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger/global/global.dart';
import 'package:passenger/helper/geofire_helper.dart';
import 'package:passenger/helper/helper_methods.dart';
import 'package:passenger/screens/rate_driver_screen.dart';
import 'package:passenger/screens/search_screen.dart';
import 'package:passenger/screens/select_nearest_active_driver_screen.dart';
import 'package:passenger/splash/splash_screen.dart';
import 'package:passenger/widgets/my_drawer.dart';
import 'package:passenger/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../info_handler/app_info.dart';
import '../models/active_nearby_available_drivers.dart';
import '../widgets/pay_fare_amount_dialog.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 220;
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "Your Name";
  String userEmail = "Your Email";

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;
  BitmapDescriptor? activeNearbyIcon;

  List<ActiveNearbyAvailableDrivers> onlineNearByAvailableDriversList = [];

  DatabaseReference? referenceRideRequest;
  String driverRideStatus = "Driver is Coming";
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;

  String userRideRequestStatus = "";
  bool requestPositionInfo = true;

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

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        // ignore: use_build_context_synchronously
        await HelperMethods.searchAddressForGeographicCoordinates(
            userCurrentPosition!, context);

    print("this is your address = $humanReadableAddress");

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListener();
    HelperMethods.readTripsKeysForOnlineUser(context);
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();
  }

  saveRideRequestInformation() {
    // Save Ride Request Information
    referenceRideRequest =
        FirebaseDatabase.instance.ref().child("All Ride Requests").push();

    var originLocation =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map originLocationMap = {
      //"key": value,
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation!.locationLongitude.toString(),
    };

    Map destinationLocationMap = {
      //"key": value,
      "latitude": destinationLocation!.locationLatitude.toString(),
      "longitude": destinationLocation!.locationLongitude.toString(),
    };

    Map userInformationMap = {
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time": DateTime.now().toString(),
      "userName": userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "driverId": "waiting",
    };

    referenceRideRequest!.set(userInformationMap);

    tripRideRequestInfoStreamSubscription =
        referenceRideRequest!.onValue.listen((eventSnap) async {
      if (eventSnap.snapshot.value == null) {
        return;
      }

      if ((eventSnap.snapshot.value as Map)["car_details"] != null) {
        setState(() {
          driverCarDetails =
              (eventSnap.snapshot.value as Map)["car_details"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverPhone"] != null) {
        setState(() {
          driverPhone =
              (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverName"] != null) {
        setState(() {
          driverName =
              (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["status"] != null) {
        userRideRequestStatus =
            (eventSnap.snapshot.value as Map)["status"].toString();
      }

      if ((eventSnap.snapshot.value as Map)["driverLocation"] != null) {
        double driverCurrentPositionLat = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["latitude"]
                .toString());
        double driverCurrentPositionLng = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["longitude"]
                .toString());

        LatLng driverCurrentPositionLatLng =
            LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        // status = accepted
        if (userRideRequestStatus == "accepted") {
          updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
        }

        // status = arrived
        if (userRideRequestStatus == "arrived") {
          setState(() {
            driverRideStatus = "Driver has Arrived";
          });
        }

        // status = on trip
        if (userRideRequestStatus == "ontrip") {
          updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
        }

        // status = ended
        if (userRideRequestStatus == "ended") {
          if ((eventSnap.snapshot.value as Map)["fareAmount"] != null) {
            double fareAmount = double.parse(
                (eventSnap.snapshot.value as Map)["fareAmount"].toString());

            var response = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext c) => PayFareAmountDialog(
                fareAmount: fareAmount,
              ),
            );

            if (response == "cashPayed") {
              // User Can Rate Driver Now
              if ((eventSnap.snapshot.value as Map)["driverId"] != null) {
                String assignedDriverId =
                    (eventSnap.snapshot.value as Map)["driverId"].toString();

                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => RateDriverScreen(
                              assignedDriverId: assignedDriverId,
                            )));

                referenceRideRequest!.onDisconnect();
                tripRideRequestInfoStreamSubscription!.cancel();
              }
            }
          }
        }
      }
    });

    onlineNearByAvailableDriversList =
        GeoFireHelper.activeNearbyAvailableDriversList;
    searchNearestOnlineDrivers();
  }

  updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;

      LatLng userPickUpPosition =
          LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo =
          await HelperMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userPickUpPosition,
      );

      if (directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus =
            "Driver is Coming :: ${directionDetailsInfo.duration_text}";
      });

      requestPositionInfo = true;
    }
  }

  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;

      var dropOffLocation =
          Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

      LatLng userDestinationPosition = LatLng(
          dropOffLocation!.locationLatitude!,
          dropOffLocation!.locationLongitude!);

      var directionDetailsInfo =
          await HelperMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userDestinationPosition,
      );

      if (directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus =
            "Going towards Destination :: ${directionDetailsInfo.duration_text}";
      });

      requestPositionInfo = true;
    }
  }

  searchNearestOnlineDrivers() async {
    // No Active Driver Available
    //TODO: TEST THIS CURLY BRACKET
    if (onlineNearByAvailableDriversList.isEmpty) {
      // Cancel / Delete Ride Request Information
      referenceRideRequest!.remove();

      setState(() {
        polyLineSet.clear();
        markersSet.clear();
        circlesSet.clear();
        pLineCoOrdinatesList.clear();
      });

      Fluttertoast.showToast(
          msg:
              "No Online Nearest Driver Available. Search Again after some time.");

      Future.delayed(const Duration(milliseconds: 4000), () {
        SystemNavigator.pop();
      //  Navigator.pop(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
      });

      return;
    }

    // Active Driver Available
    await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);

    // ignore: use_build_context_synchronously
    var response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => SelectNearestActiveDriversScreen(
                referenceRideRequest: referenceRideRequest)));
    //TODO: TEST THIS BRACKET
    if (response == "driverChoosed") {
      FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(chosenDriverId!)
          .once()
          .then((snap) {
        if (snap.snapshot.value != null) {
          // Send Notification To Specific Driver
          sendNotificationToDriverNow(chosenDriverId!);

          // Display Waiting Response UI from a Driver
          showWaitingResponseFromDriverUI();

          // Response From Driver
          FirebaseDatabase.instance
              .ref()
              .child("drivers")
              .child(chosenDriverId!)
              .child("newRideStatus")
              .onValue
              .listen((eventSnapshot) {
            // Driver Has Cancel Ride Request :: Push Notification
            if (eventSnapshot.snapshot.value == "idle") {
              Fluttertoast.showToast(
                  msg:
                      "The driver has cancelled your request. Please choose another driver.");

              Future.delayed(const Duration(milliseconds: 3000), () {
                Fluttertoast.showToast(msg: "Please Request New Ride.");

                SystemNavigator.pop();  // restarts app
             //   Navigator.pop(context, MaterialPageRoute(builder: (c)=> const MainScreen()));
              });
            }

            // Driver Has Accept Ride Request :: Push Notification
            if (eventSnapshot.snapshot.value == "accepted") {
              // Design and Display UI For Displaying Assigned Driver Information
              showUIForAssignedDriverInfo();
            }
          });
        } else {
          Fluttertoast.showToast(msg: "This driver do not exist. Try again.");
        }
      });
    }
  }

  showUIForAssignedDriverInfo() {
    setState(() {
      waitingResponseFromDriverContainerHeight = 0;
      searchLocationContainerHeight = 0;
      assignedDriverInfoContainerHeight = 240;
    });
  }

  showWaitingResponseFromDriverUI() {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverContainerHeight = 220;
    });
  }

  sendNotificationToDriverNow(String chosenDriverId) {
    // Assign/SET rideRequestId to newRideStatus In Driver's Database
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("newRideStatus")
        .set(referenceRideRequest!.key);

    // Automate Push Notification Service
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("token")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String deviceRegistrationToken = snap.snapshot.value.toString();

        // Send Notification Now
        HelperMethods.sendNotificationToDriverNow(
          deviceRegistrationToken,
          referenceRideRequest!.key.toString(),
          context,
        );

        Fluttertoast.showToast(msg: "Notification sent Successfully.");
      } else {
        Fluttertoast.showToast(msg: "Please choose another driver.");
        return;
      }
    });
  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");
    for (int i = 0; i < onlineNearestDriversList.length; i++) {
      await ref
          .child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then((dataSnapshot) {
        var driverKeyInfo = dataSnapshot.snapshot.value;
        dList.add(driverKeyInfo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    createActiveNearByDriverIconMarker();

    return Scaffold(
      key: sKey,
      drawer: SizedBox(
        width:300,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: const Color(0xff095d61),
          ),
          child: MyDrawer(
            name: userName,
            email: userEmail,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polyLineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              // Light Theme Google Map
              lightThemedGoogleMap();

              setState(() {
                bottomPaddingOfMap = 240;
              });

              locateUserPosition();
            },
          ),

          // Custom Hamburger Button For Drawer

          Positioned(
            top: 30,
            left: 14,
            child: GestureDetector(
              onTap: () {
                if (openNavigationDrawer) {
                  sKey.currentState!.openDrawer();
                } else {
                  //restart/refresh the app
                  SystemNavigator.pop();
                }
              },
              child: CircleAvatar(
                backgroundColor: const Color(0xff095d61),
                child: Icon(
                  openNavigationDrawer ? Icons.menu : Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // UI For Searching Destination
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 120),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Color(0xff095d61),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    children: [
                      // Source Location Area

                      Row(
                        children: [
                          const Icon(
                            Icons.circle_outlined,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Source",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                Provider.of<AppInfo>(context)
                                            .userPickUpLocation !=
                                        null
                                    ? "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 18)}..." //adjust 18 for range
                                    : "",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10.0),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 16.0),

                      //to
                      GestureDetector(
                        onTap: () async {
                          //go to search places screen
                          var responseFromSearchScreen = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => SearchPlacesScreen()));

                          if (responseFromSearchScreen == "obtainedDropoff") {
                            setState(() {
                              openNavigationDrawer = false;
                            });

                            //draw routes - draw polyline
                            await drawPolyLineFromOriginToDestination();
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Destination",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  Provider.of<AppInfo>(context, listen: false)
                                              .userDropOffLocation !=
                                          null
                                      ? "${(Provider.of<AppInfo>(context, listen: false).userDropOffLocation!.locationName!)}..."
                                      : "Where to go?",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10.0),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 16.0),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF4FBDB6),
                            minimumSize: const Size.fromHeight(50),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        child: const Text(
                          "Request a Ride",
                        ),
                        onPressed: () {
                          if (Provider.of<AppInfo>(context, listen: false)
                                  .userDropOffLocation !=
                              null) {
                            saveRideRequestInformation();
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Please select destination location before booking ride");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // UI For Waiting Response From Driver
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: waitingResponseFromDriverContainerHeight,
              decoration: const BoxDecoration(
                color: const Color(0xff095d61),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        'Waiting for Response\nfrom Driver',
                        duration: const Duration(seconds: 6),
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      ScaleAnimatedText(
                        'Please wait...',
                        duration: const Duration(seconds: 10),
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                            fontSize: 32.0,
                            color: Colors.white,
                            fontFamily: 'Canterbury'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //ui for displaying assigned driver information
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: assignedDriverInfoContainerHeight,
                decoration: const BoxDecoration(
                  color: const Color(0xff095d61),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //status of ride
                      Center(
                        child: Text(
                          driverRideStatus,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      const Divider(
                        height: 2,
                        thickness: 2,
                        color: Colors.white,
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),

                      //driver vehicle details
                      Text(
                        driverCarDetails,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),

                      //driver name
                      Text(
                        driverName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      const Divider(
                        height: 2,
                        thickness: 2,
                        color: Colors.white,
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      // Call Driver Button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          icon: const Icon(
                            Icons.phone_android,
                            color: Colors.white,
                            size: 22,
                          ),
                          label: const Text(
                            "Call Driver",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    var directionDetailsInfo =
        await HelperMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: const Color(0xff095d61),
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        width: 3,
        points: pLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow:
          InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: const Color(0xff095d61),
      radius: 8,
      strokeWidth: 2,
      strokeColor: const Color(0xFF4FBDB6),
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: const Color(0xff095d61),
      radius: 8,
      strokeWidth: 2,
      strokeColor: const Color(0xFF4FBDB6),
      center: destinationLatLng,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }

  initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          //whenever any driver become active/online
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireHelper.activeNearbyAvailableDriversList
                .add(activeNearbyAvailableDriver);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUsersMap();
            }
            break;

          //whenever any driver become non-active/offline
          case Geofire.onKeyExited:
            GeoFireHelper.deleteOfflineDriverFromList(map['key']);
            displayActiveDriversOnUsersMap();
            break;

          //whenever driver moves - update driver location
          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireHelper.updateActiveNearbyAvailableDriverLocation(
                activeNearbyAvailableDriver);
            displayActiveDriversOnUsersMap();
            break;

          //display those online/active drivers on user's map
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUsersMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDriversOnUsersMap() {
    setState(() {
      markersSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();

      for (ActiveNearbyAvailableDrivers eachDriver
          in GeoFireHelper.activeNearbyAvailableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId("driver" + eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }

      setState(() {
        markersSet = driversMarkerSet;
      });
    });
  }

  createActiveNearByDriverIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_android.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }
}
