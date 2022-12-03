import 'package:driver/screens/trips_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../info_handler/app_info.dart';

class EarningsTabPage extends StatefulWidget {
  const EarningsTabPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EarningsTabPageState createState() => _EarningsTabPageState();
}

class _EarningsTabPageState extends State<EarningsTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF4FBDB6),
      child: Column(
        children: [
          //earnings
          Container(
            color: const Color(0xff095d61),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  const Text(
                    "Your Earnings:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\$ ${Provider.of<AppInfo>(context, listen: false).driverTotalEarnings}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //total number of trips
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => TripsHistoryScreen()));
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xF2F2F9F9),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Image.asset(
                      "images/car_logo.png",
                      width: 100,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const Text(
                      "Trips Completed",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Provider.of<AppInfo>(context, listen: false)
                            .allTripsHistoryInformationList
                            .length
                            .toString(),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
