import 'package:driver/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../global/global.dart';
import '../widgets/info_design_ui.dart';

class ProfileTabPage extends StatefulWidget
{
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor:  const Color(0xFF4FBDB6),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //name
            Text(
              onlineDriverData!.name!,
              style: const TextStyle(
                fontSize: 50.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),


            Text(
              "$titleStarsRating driver",
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 2,
              ),
            ),

            const SizedBox(height: 38.0,),


            //phone
            InfoDesignUIWidget(
              textInfo: onlineDriverData.phone!,
              iconData: Icons.phone_iphone,
            ),

            //email
            InfoDesignUIWidget(
              textInfo: onlineDriverData.email!,
              iconData: Icons.email,
            ),

            InfoDesignUIWidget(
              textInfo: "${onlineDriverData.car_color!} ${onlineDriverData.car_model!} ${onlineDriverData.car_number!}",
              iconData: Icons.car_repair,
            ),



            const SizedBox(
              height: 50,
            ),

            ElevatedButton(
              onPressed: ()
              {
                fAuth.signOut();
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 140,
                    vertical: 20
                ),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )

          ],
        ),
      ),
    );
  }
}
