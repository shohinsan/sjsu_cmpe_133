import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger/authentication/login_screen.dart';
import 'package:passenger/global/global.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              lightThemedGoogleMap();

              },
          ),
        ],
      ),
    );
  }
}
