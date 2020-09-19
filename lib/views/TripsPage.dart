import 'package:flutter/material.dart';

class TripsPage extends StatefulWidget {
  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: new AppBar(
      //   title:new Text("Trips Page"),
      // ),
      body:new Center(
          child: new Text("This is Trips Page")
      ),
    );
  }
}
