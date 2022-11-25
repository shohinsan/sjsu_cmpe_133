import 'package:driver/screens/profile_tab.dart';
import 'package:driver/screens/ratings_tab.dart';
import 'package:driver/screens/earning_tab.dart';
import 'package:driver/screens/home_tab.dart';
import 'package:driver/screens/profile_tab.dart';
import 'package:driver/screens/ratings_tab.dart';
import 'package:flutter/material.dart';

import 'earning_tab.dart';
import 'home_tab.dart';

class TabsController extends StatefulWidget {
  @override
  _TabsControllerState createState() => _TabsControllerState();
}

class _TabsControllerState extends State<TabsController> with SingleTickerProviderStateMixin {

  TabController? tabController;
  int selectedIndex = 0;
  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,

        children: const [
          HomeTabPage(),
          EarningsTabPage(),
          RatingsTabPage(),
          ProfileTabPage(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(

          items: const [

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: "Earnings",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Ratings",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Account",
            ),
          ],

          unselectedItemColor: const Color(0xFF4FBDB6),
          selectedItemColor: const Color(0xff095d61),
          selectedLabelStyle: const TextStyle(fontSize: 18),
          showUnselectedLabels: true,
          currentIndex: selectedIndex,
          onTap: onItemClicked,

        ),

    );

  }
}
