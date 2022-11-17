import 'package:driver/global/global.dart';
import 'package:driver/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';


class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  _ProfileTabPageState createState() => _ProfileTabPageState();
}



class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text(
          "Sign Out",
        ),
        onPressed: ()
        {
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        },
      ),
    );
  }
}
