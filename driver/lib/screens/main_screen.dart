import 'package:driver/screens/profile_tab.dart';
import 'package:driver/screens/ratings_tab.dart';
import 'package:driver/screens/earning_tab.dart';
import 'package:driver/screens/home_tab.dart';
import 'package:driver/screens/profile_tab.dart';
import 'package:driver/screens/ratings_tab.dart';
import 'package:flutter/material.dart';

import 'earning_tab.dart';
import 'home_tab.dart';

class MainScreen extends StatefulWidget
{
  @override
  _MainScreenState createState() => _MainScreenState();
}




class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin
{
  TabController? tabController;
  int selectedIndex = 0;


  onItemClicked(int index)
  {
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
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),

    );
  }
}
