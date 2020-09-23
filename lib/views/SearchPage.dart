import 'package:flutter/material.dart';
import 'package:flutter_app/views/SearchBus.dart';
import 'package:flutter_app/views/SearchMRT.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin{

  // List<Widget> containers =  [
  //   Container(
  //     child: new Text("This is Bus"),
  //     alignment: Alignment(0.0, 0.0),
  //
  //   ),
  //   Container(
  //     child: new Text("This is MRT"),
  //     alignment: Alignment(0.0, 0.0),
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('AppName (TBC)'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.directions_bus),
                text: 'BUS',
              ),
              Tab(
                icon: Icon(Icons.train),
                text: 'MRT',
              ),
            ]
          )
        ),
        body: TabBarView(
          children: <Widget>[
            SearchBus(),
            SearchMRT(),
          ],
        ),
      ),
    );
  }
}
