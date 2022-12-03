
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passenger/helper/helper_methods.dart';
import 'package:passenger/splash/splash_screen.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../global/global.dart';
import 'main_screen.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget {
  DatabaseReference? referenceRideRequest;
  SelectNearestActiveDriversScreen({this.referenceRideRequest});

  @override
  _SelectNearestActiveDriversScreenState createState() => _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState extends State<SelectNearestActiveDriversScreen> {

  String fareAmount = "\$${HelperMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)}";     //\$${HelperMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)}

  getFareAmountAccordingToVehicleType(int index) {
    if(tripDirectionDetailsInfo != null) {
      if(dList[index]["car_details"]["type"].toString() == "Car") {
        fareAmount = (HelperMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)).toStringAsFixed(2);  //cents 0.72
      }

      // if(dList[index]["car_details"]["type"].toString() == "minibus") //means executive type of car - more comfortable pro level
      //     {
      //   fareAmount = (HelperMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 2).toStringAsFixed(2);
      // }
      // if(dList[index]["car_details"]["type"].toString() == "minivan") // non - executive car - comfortable normal
      //     {
      //   fareAmount = (HelperMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)).toString();
      // }
    }
    return fareAmount;
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white54,
        title: const Text(
          "Nearest Online Drivers",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(     //close button
              Icons.close, color: Colors.red
          ),
          onPressed: ()
          {
            //delete/remove the ride request from database
            widget.referenceRideRequest!.remove();
            Fluttertoast.showToast(msg:"You have cancelled the ride");
            SystemNavigator.pop();
            //Navigator.pop(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
          },
        ),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                chosenDriverId = dList[index]["id"].toString();
              });
              Navigator.pop(context, "driverChoosed");
            },
            child: Card(
              color: Colors.white,
              elevation: 3,
              shadowColor: Colors.white,
              margin: const EdgeInsets.all(8),

              child: dList[index]["car_details"] !=null&& dList[index]["car_details"]['type'] !=null ? ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Image.asset(
                    "images/${dList[index]["car_details"]["type"]}.png",
                    width: 70,
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      dList[index]["name"],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      dList[index]["car_details"]["car_model"],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    SmoothStarRating(
                      rating: dList[index]["rating"] == null ? 0.0 : double.parse(dList[index]["rating"]),
                      color: Colors.black,
                      borderColor: Colors.black,
                      allowHalfRating: true,
                      starCount: 5,
                      size: 15,
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      //"\$"+HelperMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!).toString(),
                      // ignore: prefer_interpolation_to_compose_strings
                      "\$"+ getFareAmountAccordingToVehicleType(index),     //car type = car, half cost dest-origin. working as intended now
                      style:const  TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2,),
                    Text(
                      tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.duration_text! : " ",
                      style:const TextStyle(
                          fontWeight: FontWeight.bold,
                      //    color: Colors.black54,
                          fontSize: 14
                      ),
                    ),
                    const SizedBox(height: 2,),
                    Text(
                      tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.distance_text! : "",
                      style:const TextStyle(
                          fontWeight: FontWeight.bold,
                        //  color: Colors.black54,
                          fontSize: 14
                        ),
                     ),
                    ],
                  ),
                ) : Align(), //if car details is null, caused by line 84
              ),
            );
          },
        ),
      );
    }
  }

