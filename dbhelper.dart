import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/models/Route.dart';

class DBHelper{
  static Database _db;
  static final _tablename = 'routeTable';
  static final routeID = '_routeID';
  static final busNo = 'busNo';
  static final fromStop = 'fromStop';
  static final toStop = 'toStop';
  static final fare = 'fare';
  static final tripID = 'tripID';
  static final _tripsTable = 'tripsTable';
  static final totalFare = 'totalFare';

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        '''
      CREATE TABLE $_tablename(
      $routeID INTEGER PRIMARY KEY,
      $busNo TEXT,
      $fromStop TEXT,
      $toStop TEXT,
      $fare DOUBLE,
      $tripID INTEGER ); 
      
      '''
    );
    print("Created route tables");

    await db.execute(
        '''      
      CREATE TABLE $_tripsTable(
      $tripID INTEGER PRIMARY KEY,
      $totalFare DOUBLE);
      '''
    );
    print("Created trips tables");

    await db.execute(
        '''
          INSERT INTO $_tripsTable 
          VALUES (1,0);
    
        ''');
    print("Inserted default values into trips tables");
  }

  // void saveRoute(Routes route) async {
  //   var dbClient = await db;
  //   await dbClient.transaction((txn) async {
  //     return await txn.rawInsert(
  //         'INSERT INTO $_tablename($busNo, $fromStop, $toStop, $fare, $tripID ) VALUES(' +
  //             '\'' +
  //             route.busNo +
  //             '\'' +
  //             ',' +
  //             '\'' +
  //              route.fromStop +
  //             '\'' +
  //             ',' +
  //             '\'' +
  //              route.toStop +
  //             '\'' +
  //             ',' +
  //             '\'' +
  //             route.fare.toString() +
  //             '\'' +
  //             ',' +
  //             '\'' +
  //             route.tripID.toString() +
  //             '\'' +
  //             ')');
  //   });
  // }


  Future<int> saveRoute(Map<String,dynamic> row) async{
    // Database db =  await instance.database;
    // return await db.insert(_tablename, row);
    var dbClient = await db;
    return await dbClient.insert(_tablename, row);
  }

  // Future<int> addToTrips(Map<String,dynamic> row) async{
  //   // Database db =  await instance.database;
  //   // return await db.insert(_tablename, row);
  //   var dbClient = await db;
  //   await dbClient.transaction((txn) async {
  //
  //   }
  // }

  Future<int> saveTrip(Map<String,dynamic> row) async{
    var dbClient = await db;
    return await dbClient.insert(_tripsTable, row);
  }

  Future<List<Map>> getAllTripsID() async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT $tripID FROM $_tripsTable ');
    return list;
  }

  Future<List<Routes>> getRoute() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(' SELECT * FROM $_tablename ');
    List<Routes> route = new List();
    for (int i = 0; i < list.length; i++) {
      route.add(new Routes(list[i]["_routeID"], list[i]["busNo"], list[i]["fromStop"], list[i]["toStop"], list[i]["fare"],list[i]["tripID"]));
    }
    print('route length is '+ route.length.toString());
    return route;
  }

  Future<List<Routes>> getRouteByTripID(int id) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(' SELECT * FROM $_tablename WHERE $tripID LIKE "%$id%" ');
    List<Routes> route = new List();
    for (int i = 0; i < list.length; i++) {
      route.add(new Routes(list[i]["_routeID"], list[i]["busNo"], list[i]["fromStop"], list[i]["toStop"], list[i]["fare"],list[i]["tripID"]));
    }
    print('route length is '+ route.length.toString());
    return route;
  }
  
  Future<List<Map>> getFaresByTripsID(int id) async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT SUM(fare) FROM $_tablename WHERE $tripID LIKE  "%$id%"');
    return list;
  }

  Future<int> deleteRoute(int id) async{
    var dbClient = await db;
    return await dbClient.delete(_tablename,where:'$routeID = ?',whereArgs:[id]);
  }
}