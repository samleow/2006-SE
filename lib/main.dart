import 'package:flutter/material.dart';
import 'package:flutter_app/models/BusStops.dart';
import 'package:flutter_app/views/Homepage.dart';
import 'package:flutter_app/views/TypeSelectionPage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/services/CallAPIServices.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:flutter_app/controllers/SearchRouteController.dart';
import 'package:flutter_app/controllers/CompareFareController.dart';
import 'package:flutter_app/controllers/CalculateFareController.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => CallAPIServices());
  GetIt.instance.registerLazySingleton(() => SearchRouteController());
  GetIt.instance.registerLazySingleton(() => CompareFareController());
  GetIt.instance.registerLazySingleton(() => CalculateFareController());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnFare SG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  CallAPIServices get service => GetIt.I<CallAPIServices>();
  static bool _isLoading = true;
  static bool _loadSuccess = false;

  _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    // uses a single boolean to check for fetching errors
    // may need to change to individual booleans for each data call
    _loadSuccess = await service.callBusStopsAPI() &&
        await service.callBusServicesAPI() &&
        await service.callBusRoutesAPI() &&
        await service.callBusFaresAPI() &&
        await service.callMCListAPI() &&
        await service.callMRTFaresAPI() &&
        await service.retrieveMRTRoutes();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    if(_isLoading)
      _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future checkFirstSeen() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool _seen = (prefs.getBool('seen') ?? false);

      if(_seen){
        print('seen is ' + _seen.toString());
        Future.delayed(Duration.zero, () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          );
        });
      } else {
        await prefs.setBool('seen', true);
        print('seen is ' + _seen.toString());
        Future.delayed(Duration.zero, () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TypeSelectionPage()),
          );
        });
      }
    }
    if(!_isLoading) {
      if(!_loadSuccess)
        return Center(child: Text("ERROR RETRIEVING DATA FROM API: SearchBus"));
      else {
        checkFirstSeen();
      }
    }

    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.blueAccent),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "   Loading....",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 25,
                ),
                SpinKitWave(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.white : Colors.orangeAccent,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ));
  }
}

