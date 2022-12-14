import 'dart:async';

import 'package:driver/authentication/login_screen.dart';
import 'package:driver/screens/home_tab.dart';
import 'package:driver/authentication/login_screen.dart';
import 'package:driver/authentication/signup_screen.dart';
import 'package:driver/global/global.dart';
import 'package:driver/screens/tabs_controller.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (await fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => TabsController()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    // 095D61FF
    return Material(
      child: Container(
        color: const Color(0xff095d61),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [

                  Image(
                    image: AssetImage('images/logo-large.png'),
                    width: 500.0,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),

                  Text(
                    "S P A R T A N",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  SizedBox(height: 10,),

                  Text(
                    "S H A R E",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
