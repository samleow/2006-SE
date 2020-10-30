import 'package:flutter/material.dart';
import 'package:flutter_app/views/MapPage.dart';
import 'package:flutter_app/views/ComparePage.dart';
import 'package:flutter_app/views/SearchPage.dart';
import 'package:flutter_app/views/TripsPage.dart';
import 'MapPage.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    SearchPage(),
    TripsPage(),
    ComparePage(),
    MapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.search),
            title: new Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.event_note),
            title: new Text('Trips'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows),
              title: Text('Compare')
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.map),
            title: new Text('Map'),
          ),
        ],
      ),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}


