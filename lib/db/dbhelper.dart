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
  static final transportID = 'transportID';
  static final fromStop = 'fromStop';
  static final toStop = 'toStop';
  static final fare = 'fare';
  static final tripID = 'tripID';
  static final _tripsTable = 'tripsTable';
  static final totalFare = 'totalFare';
  static final BUSorMRT = 'BUSorMRT';
  static final fareType = 'fareType';

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
      $transportID TEXT,
      $fromStop TEXT,
      $toStop TEXT,
      $fare DOUBLE,
      $tripID INTEGER,
      $BUSorMRT TEXT, 
      $fareType TEXT); 
      
      '''
    );

    await db.execute(
        '''      
      CREATE TABLE $_tripsTable(
      $tripID INTEGER PRIMARY KEY,
      $fareType TEXT);
      '''
    );

    await db.execute(
        '''
          INSERT INTO $_tripsTable 
          VALUES (1,'Adult');
        ''');
  }

  Future<int> saveRoute(Map<String,dynamic> row) async{
    var dbClient = await db;
    return await dbClient.insert(_tablename, row);
  }

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
      route.add(new Routes(list[i]["_routeID"], list[i]["transportID"], list[i]["fromStop"], list[i]["toStop"], list[i]["fare"],list[i]["tripID"],list[i]["BUSorMRT"],list[i]["fareType"]));
    }
    return route;
  }

  Future<List<Routes>> getRouteByTripID(int id) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(' SELECT * FROM $_tablename WHERE $tripID LIKE "%$id%" ');
    List<Routes> route = new List();
    for (int i = 0; i < list.length; i++) {
      route.add(new Routes(list[i]["_routeID"], list[i]["transportID"], list[i]["fromStop"], list[i]["toStop"], list[i]["fare"],list[i]["tripID"],list[i]["BUSorMRT"],list[i]["fareType"]));
    }
    return route;
  }
  
  Future<List<Map>> getFaresByTripsID(int id) async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT SUM(fare) FROM $_tablename WHERE $tripID LIKE  "%$id%"');
    return list;
  }

  Future<List<Map>> getBothFaresByTripsID(int id1, int id2) async{
    var dbClient = await db;
    List<Map> list1 = await dbClient.rawQuery('SELECT SUM(fare) FROM $_tablename WHERE $tripID LIKE  "%$id1%"');
    List<Map> list2 = await dbClient.rawQuery('SELECT SUM(fare) FROM $_tablename WHERE $tripID LIKE  "%$id2%"');
    List<Map> list3 = new List<Map>();
    list3 = [list1[0],list2[0]];
    return list3;
  }

  Future<int> deleteRoute(int id) async{
    var dbClient = await db;
    return await dbClient.delete(_tablename,where:'$routeID = ?',whereArgs:[id]);
  }

  Future<int> deleteTrip(int id) async{
    var dbClient = await db;
    List<Map> maxTripId = await getMaxTripId();
    List<dynamic> newMaxTripId = maxTripId.map((m)=>m['MAX(tripID)']).toList();
    List<Map> minTripId = await getMinTripId();
    List<dynamic> newMinTripId = minTripId.map((m)=>m['MIN(tripID)']).toList();

    if(newMaxTripId[0] == newMinTripId[0]){
      return await dbClient.delete(_tablename,where:'$tripID = ?',whereArgs:[id]);
    } else if(id == newMaxTripId[0]) {
      await dbClient.delete(_tripsTable, where: '$tripID = ?', whereArgs: [id]);
      return await dbClient.delete(_tablename, where: '$tripID = ?', whereArgs: [id]);
    } else {
      await dbClient.delete(_tripsTable,where:'$tripID = ?',whereArgs:[id]);
      await dbClient.delete(_tablename,where:'$tripID = ?',whereArgs:[id]);
      await dbClient.rawQuery('UPDATE $_tripsTable SET $tripID = $tripID - 1 WHERE $tripID NOT IN (1);');
      await dbClient.rawQuery('UPDATE $_tablename SET $tripID = $tripID - 1 WHERE $tripID NOT IN (1);');
      return 1000000;
    }
    }

  void updateFareType(int i) async{
    var dbClient = await db;
    await dbClient.delete(_tripsTable);
    await dbClient.delete(_tablename); // Route
    if(i == 1) {
      await dbClient.rawQuery('INSERT INTO $_tripsTable VALUES (1,"Adult") ');
    } else if(i == 2){
      await dbClient.rawQuery('INSERT INTO $_tripsTable VALUES (1,"Senior Citizen") ');
    } else
      await dbClient.rawQuery('INSERT INTO $_tripsTable VALUES (1,"Student") ');
  }

  Future<List<Map>> getFareType() async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT FareType FROM $_tripsTable WHERE $tripID = 1');
    return list;
  }

  Future<List<Map>> getMaxTripId() async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT MAX($tripID) FROM $_tripsTable');
    return list;
  }

  Future<List<Map>> getMinTripId() async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT MIN($tripID) FROM $_tripsTable');
    return list;
  }
}