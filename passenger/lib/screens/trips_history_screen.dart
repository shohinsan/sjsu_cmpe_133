import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../info_handler/app_info.dart';
import '../widgets/history_design_ui.dart';
import '../widgets/my_drawer.dart';

class TripsHistoryScreen extends StatefulWidget {
  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();
}

class _TripsHistoryScreenState extends State<TripsHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff095d61),
      appBar: AppBar(
        backgroundColor: const Color(0xff095d61),
        title: const Text("Trips History"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, MaterialPageRoute(builder: (c)=>  MyDrawer()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          separatorBuilder: (context, i) => const Divider(
            color: Colors.white,
            thickness: 2,
            height: 2,
          ),
          itemBuilder: (context, i) {
            return Card(
              color: Colors.white,
              child: HistoryDesignUIWidget(
                tripsHistoryModel: Provider.of<AppInfo>(context, listen: false)
                    .allTripsHistoryInformationList[i],
              ),
            );
          },
          itemCount: Provider.of<AppInfo>(context, listen: false)
              .allTripsHistoryInformationList
              .length,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
        ),
      ),
    );
  }
}
