import 'package:flutter/material.dart';

import '../models/directions.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation;


  void updatePickUpLocationAddress(Directions pickUpLocationAddress) {
    userPickUpLocation = pickUpLocationAddress;
    notifyListeners();
  }

}