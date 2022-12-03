import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InfoDesignUIWidget extends StatefulWidget {
  String? textInfo;
  IconData? iconData;

  InfoDesignUIWidget({Key? key, this.textInfo, this.iconData}) : super(key: key);

  @override
  State<InfoDesignUIWidget> createState() => _InfoDesignUIWidgetState();
}

class _InfoDesignUIWidgetState extends State<InfoDesignUIWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xF2F2F9F9),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: ListTile(
        leading: Icon(
          widget.iconData,
          color: Colors.black,
        ),
        title: Text(
          widget.textInfo!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
