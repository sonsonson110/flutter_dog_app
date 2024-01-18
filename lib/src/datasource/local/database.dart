import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  static const dogTABLE = "tblDog";
  static const breedTABLE = "tblBreed";
  static const savedDogTABLE = "tblSavedDog";

  static const createDogTableSql = '''
    CREATE TABLE $dogTABLE (
            id TEXT PRIMARY KEY,
            url TEXT NOT NULL
        );
    ''';

  static const createBreedTableSql = '''
    CREATE TABLE $breedTABLE (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        temperament TEXT
    );
  ''';
  static const createSavedDogTable = '''
    CREATE TABLE $savedDogTABLE (
        id INTEGER PRIMARY KEY,
        dogId TEXT REFERENCES tblDog(id) ON DELETE CASCADE ON UPDATE CASCADE,
        breedId INTEGER REFERENCES tblBreed(id) ON DELETE CASCADE ON UPDATE CASCADE
    );
  ''';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      log("database object returned");
      return _database!;
    }
    _database = await createDatabase();
    log("database object returned");
    return _database!;
  }

  Future<Database> createDatabase() async {
    // this dir is not exposed to user
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    // set name for db file
    String databaseName = "localDogDb.db";
    String path = join(documentDirectory.path, databaseName);

    // create db structure
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: initDB,
    );
    return database;
  }

  Future initDB(Database database, int version) async {
    await database.execute(createDogTableSql);
    await database.execute(createBreedTableSql);
    await database.execute(createSavedDogTable);
    log("database initialized");
  }
}
