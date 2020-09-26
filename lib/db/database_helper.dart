import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseHelper {

  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;
  static final _tablename = 'routeTable';
  static final routeID = '_routeID';
  static final busNo = 'busNo';
  static final fromStop = 'fromStop';
  static final toStop = 'toStop';
  static final fare = 'fare';
  static final tripID = 'tripID';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async{
    if(_database != null) return _database;

    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,_dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version){
    db.execute(
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
  }

  Future<int> insert(Map<String,dynamic> row) async{
    Database db =  await instance.database;
    return await db.insert(_tablename, row);
  }

  Future<List<Map<String,dynamic>>> queryAll() async{
    Database db =  await instance.database;
    return await db.query(_tablename);
  }

  Future update(Map<String,dynamic> row) async{
    Database db = await instance.database;
    int id = row[routeID];
    return await db.update(_tablename, row, where:'$routeID = ?',whereArgs: [id]);
  }

  Future<int> delete(int id) async{
    Database db = await instance.database;
    return await db.delete(_tablename,where:'$routeID = ?',whereArgs:[id]);
  }
}