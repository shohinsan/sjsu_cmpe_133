import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger/authentication/login_screen.dart';
import 'package:passenger/global/global.dart';
import 'package:passenger/helper/geofire_helper.dart';
import 'package:passenger/helper/helper_methods.dart';
import 'package:passenger/screens/search_screen.dart';
import 'package:passenger/widgets/my_drawer.dart';
import 'package:passenger/widgets/progress_dialog.dart';

import 'package:provider/provider.dart';
import '../info_handler/app_info.dart';
import '../models/active_nearby_available_drivers.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );



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

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  //for end and starting point clarity markers
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  String userName = "Your Name";
  String userEmail = "Your Email Address";

  bool openNavigationDrawer = true;
  bool activeNearbyDriverKeysLoaded = false;
  BitmapDescriptor? activeNearbyIcon;
  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateUserPosition() async {
    Position currPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = currPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await HelperMethods.searchAddressForGeographicCoordinates(
            userCurrentPosition!, context);
    print("This is your current position = $humanReadableAddress");
    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;
    initializeGeoFireListener();
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    createActiveNearByDriverIconMarker();
    return Scaffold(
      key: scaffoldKey,
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xff095d61),
        ),
        child: MyDrawer(
          name: userName,
          email: userEmail,
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
              lightThemedGoogleMap();

              setState(() {
                bottomPaddingOfMap = 300;
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
                if(openNavigationDrawer) {
                  scaffoldKey.currentState!.openDrawer();
                }
                else{
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
                            children:  [
                              const Text(
                                "Source",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                Provider.of<AppInfo>(context).userPickUpLocation != null
                                    ? "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,18)}..." //adjust 18 for range
                                    : "",
                                style: const TextStyle(color: Colors.white, fontSize: 14),
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

                      // Destination Location Area

                      GestureDetector(
                        onTap: () async{
                          var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  SearchPlacesScreen()));

                      //    if(responseFromSearchScreen != null){
                       //     responseFromSearchScreen.then((value) {
                              if(responseFromSearchScreen == "obtainedDropoff"){
                                // draw routes / polyline
                                await drawPolyLineFromOriginToDestination();

                                setState(() {
                                  openNavigationDrawer = false;
                                });
                              }
                        //    });
                        //  }
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
                                  Provider.of<AppInfo>(context, listen: false).userDropOffLocation != null
                                      ? "${(Provider.of<AppInfo>(context, listen: false).userDropOffLocation!.locationName!).substring(0,18)}..."
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF4FBDB6),
                            minimumSize: const Size.fromHeight(50),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        child: const Text(
                          "Request a Ride",
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

  Future <void> drawPolyLineFromOriginToDestination() async{
    var originPosition = Provider.of<AppInfo>(context,listen:false).userPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context,listen:false).userDropOffLocation;
    var originLatLng=LatLng(originPosition!.locationLatitute!, originPosition.locationLongitude!);
    var destinationLatLng=LatLng(destinationPosition!.locationLatitute!, destinationPosition.locationLongitude!);
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(message: "Please wait...",),
    );

    var directionDetailsInfo = await HelperMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_points!);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList = pPoints.decodePolyline(directionDetailsInfo.e_points!);

    if(decodedPolyLinePointsResultList.isNotEmpty)
    {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng)
      {
        pLineCoOrdinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.greenAccent,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
    });

    //fixing camera zoom by adjusting map.
    LatLngBounds boundsLatLng;
    if(originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    }
    else if(originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    }
    else if(originLatLng.latitude > destinationLatLng.latitude)
    {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    }
    else
    {
      boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }
    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );
      Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"), infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
    );
      setState(() {
        markersSet.add(originMarker);
        markersSet.add(destinationMarker);
      });

      Circle originCircle = Circle(
        circleId: const CircleId("originID"),
        fillColor: Colors.blue,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,    //border white
        center: originLatLng,
      );

      Circle destinationCircle = Circle(
        circleId: const CircleId("destinationID"),
        fillColor: Colors.red,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
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
        userCurrentPosition!.latitude, userCurrentPosition!.longitude,
        100)! //10 km circle from user position display drivers
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
        //whenever any driver become active/online
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireHelper.activeNearbyAvailableDriversList.add(
                activeNearbyAvailableDriver);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUsersMap();
            }
            break;

        //whenever any driver become non-active/offline
          case Geofire.onKeyExited:
            GeoFireHelper.deleteOfflineDriverFromList(map['key']);
            displayActiveDriversOnUsersMap();
            break;

        //whenever driver moves update driver location
          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
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
  displayActiveDriversOnUsersMap()
  {
    setState(() {
      markersSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();

      for(ActiveNearbyAvailableDrivers eachDriver in GeoFireHelper.activeNearbyAvailableDriversList)
      {
        LatLng eachDriverActivePosition = LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId("driver"+eachDriver.driverId!),
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

  createActiveNearByDriverIconMarker()
  {
    if(activeNearbyIcon == null)
    {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(1, 1));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_android.png").then((value)
      {
        activeNearbyIcon = value;
      });
    }
  }
}

