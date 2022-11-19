import 'package:flutter/material.dart';

import '../models/directions.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;


  void updatePickUpLocationAddress(Directions pickUpLocationAddress) {
    userPickUpLocation = pickUpLocationAddress;
    notifyListeners();
  }


  void updateDropOffLocationAddress(Directions dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }



}