import 'package:flutter/material.dart';
import 'package:flutter_app/models/MClist.dart';
import 'package:flutter_app/views/Homepage.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/services/MClist_service.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => MClistService());
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
      home: MCList(),
    );
  }
}
