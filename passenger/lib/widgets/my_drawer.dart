import 'package:flutter/material.dart';
import 'package:passenger/global/global.dart';
import 'package:passenger/splash/splash_screen.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? email;

  MyDrawer({Key? key, this.name, this.email}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Drawer Header
          Container(
            height: 165,
            color: const Color(0xFF4FBDB6),
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff095d61),
              ),
              child: Row(children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 80,
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.name.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.email.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              ]),
            ),
          ),

          // Drawer Body


          GestureDetector(
            onTap: () {

              },
            child: const ListTile(
              leading: Icon(
                Icons.history,
                color: Colors.white,
              ),
              title: Text(
                "History",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {

            },
            child: const ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.white,
              ),
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {

            },
            child: const ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.white,
              ),
              title: Text(
                "About",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),


          GestureDetector(
            onTap: () {
              fAuth.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MySplashScreen()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: Text(
                "Sign Out",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),






        ],
      ),
    );
  }
}
