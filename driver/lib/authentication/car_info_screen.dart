import 'package:driver/global/global.dart';
import 'package:driver/splash/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../splash/splash_screen.dart';

class CarInfoScreen extends StatefulWidget {

  @override
  _CarInfoScreenState createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypesList = ["Car", "Minivan", "Minibus"];
  String? selectedCarType;

  saveCarInfo() {
    Map driverCarInfoMap = {
      "car_color": carColorTextEditingController.text.trim(),
      "car_number": carNumberTextEditingController.text.trim(),
      "car_model": carModelTextEditingController.text.trim(),
      "type": selectedCarType,
    };

    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
    driversRef.child(currentFirebaseUser!.uid).child("car_details").set(driverCarInfoMap);

    Fluttertoast.showToast(msg: "Car Details has been saved, Congratulations.");
    Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff095d61),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [

              const SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo-large.png"),
              ),

              const SizedBox(height: 10,),

              const Text(
                "Enter Car Details",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20,),


              TextField(
                controller: carModelTextEditingController,
                style: const TextStyle(
                    color: Colors.white
                ),
                decoration: const InputDecoration(
                  labelText: "Car Model",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),


              const SizedBox(height: 20,),


              TextField(
                controller: carNumberTextEditingController,
                style: const TextStyle(
                    color: Colors.white
                ),
                decoration: const InputDecoration(
                  labelText: "Car Number",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20,),



              TextField(
                controller: carColorTextEditingController,
                style: const TextStyle(
                    color: Colors.white
                ),
                decoration: const InputDecoration(
                  labelText: "Car Color",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              DropdownButton(
                iconSize: 26,
                dropdownColor: const Color(0xFF4FBDB6),
                hint: const Text(
                  "Please choose Car Type",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: const Color(0xFF4FBDB6),
                  ),
                ),
                value: selectedCarType,
                onChanged: (newValue)
                {
                  setState(() {
                    selectedCarType = newValue.toString();
                  });
                },
                items: carTypesList.map((car){
                  return DropdownMenuItem(
                    value: car,
                    child: Text(
                      car,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 130,),

              ElevatedButton(
                onPressed: ()
                {
                  if(carColorTextEditingController.text.isNotEmpty
                      && carNumberTextEditingController.text.isNotEmpty
                      && carModelTextEditingController.text.isNotEmpty && selectedCarType != null)
                  {
                    saveCarInfo();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF4FBDB6),
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                child: const Text(
                  "Save Now",
                  style: TextStyle(

                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
