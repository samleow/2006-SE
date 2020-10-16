import 'package:flutter/material.dart';
import 'package:flutter_app/views/Homepage.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/services/CallAPIServices.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => CallAPIServices());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
    _loadSuccess = await service.callBusFaresAPI() &&
        await service.callBusRoutesAPI() &&
        await service.callBusServicesAPI() &&
        await service.callBusStopsAPI() &&
        await service.callMCListAPI();

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

    if(!_isLoading) {
      if(!_loadSuccess)
        return Center(child: Text("ERROR RETRIEVING DATA FROM API: SearchBus"));
      else {
        Future.delayed(Duration.zero, () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          );
        });
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

