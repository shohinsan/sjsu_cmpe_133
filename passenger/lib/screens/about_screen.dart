import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/my_drawer.dart';

class AboutScreen extends StatefulWidget {
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff095d61),
      body: ListView(
        children: [
          //image
          Container(
            height: 230,
            child: Center(
              child: Image.asset(
                "images/carpool.png",
                width: 260,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                //company name
                const Text(
                  "SpartanShare Carpool App",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //about you & your company - write some info
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "This app has been developed by students of San Jose State University."
                    "Fun fact, we are the first users to use this app.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Credits to Shohin Abdulkhamidov and Saim Sheikh",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                // Close Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, MaterialPageRoute(builder: (c)=>  MyDrawer()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 145, vertical: 20),
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
