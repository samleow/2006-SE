import 'package:flutter/material.dart';
import 'package:flutter_app/models/BusRoutes.dart';
import 'package:flutter_app/models/api_response.dart';
import 'package:flutter_app/views/CompareTrips.dart';
import 'package:flutter_app/views/ConcessionPage.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/services/CallAPIServices.dart';

import 'ConcessionPage.dart';
// import 'package:flutter_app/views/CompareTrips.dart';


class ComparePage extends StatefulWidget {
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text('AppName (TBC)'),
            bottom: TabBar(
            key: _formKey,
            tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.directions),
                    text: 'TRIPS',
                  ),
                  Tab(
                    icon: Icon(Icons.credit_card),
                    text: 'CONCESSION PASS',
                  ),
                ]
            )
        ),
        body: TabBarView(
          children: <Widget>[
            CompareTrips(),
            ConcessionPage()
    ],
        ),
      ),
    );
  }
}
