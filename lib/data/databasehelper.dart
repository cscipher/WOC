import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbname = 'mydb.db';
  static final tablename = 'contactInfo';
  static final _dbversion = 2;

  static final colId = 'id';
  static final colName = 'contactNames';
  static final colStatus = 'contactStatus';
  static final colNum = 'contactNum';
  static final colPic = 'contactPic';

  DatabaseHelper._();

  static final DatabaseHelper db = DatabaseHelper._();
  static Database _database;

  // Future<Database> get database async {
  //   if (_database != null) return _database;

  //   // if _database is null we instantiate it
  //   print('inside getter');
  //   _database = await initDB();
  //   return _database;
  // }

  Future<Database> initDB() async {
    print("initDB executed");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(await getDatabasesPath(), _dbname);
    String path = join(documentsDirectory.path, _dbname);
    // await deleteDatabase(path);

    _database = await openDatabase(path, version: _dbversion,
        onCreate: (Database db, int version) async {
      await db.execute('''
       CREATE TABLE $tablename ( 
         $colId TEXT PRIMARY KEY,
         $colName TEXT NOT NULL,
         $colNum TEXT NOT NULL,
         $colStatus TEXT NOT NULL,
         $colPic TEXT NOT NULL
       )
       ''');
    });
    return _database;
  }

  // Future _createTable(Database db, int version) async {
  //   await db.execute('''
  //     CREATE TABLE $_tablename(
  //       $colId TEXT PRIMARY KEY,
  //       $colName TEXT NOT NULL,
  //       $colNum TEXT NOT NULL
  //     )
  //     ''');
  // }

  //Insert function
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await initDB();
    return await db.insert(tablename, row);
  }

  // Query function
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await initDB();

    return await db.query(tablename);
  }
  Future<List<Map<String, dynamic>>> query(String queryString, List args) async {
    Database db = await initDB();

    return await db.rawQuery(queryString, args);
  }

  // //update function
  Future update(Map<String, dynamic> row) async {
    Database db = await initDB();
    String id = row[colId];
    return await db
        .update(tablename, row, where: '$colId = ?', whereArgs: [id]);
  }

  Future<void> deleteDatabase() async {
    // await db.deleteDatabase().then((value) => print('deleted'));
    Database db = await initDB();
    return await db.delete(tablename).then((value) => print('deleted'));
  }
}
