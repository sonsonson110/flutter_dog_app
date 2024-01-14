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
            id INTEGER PRIMARY KEY,
            url TEXT NOT NULL,
            imageName TEXT NOT NULL
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
        dogId INTEGER REFERENCES tblDog(id) ON DELETE CASCADE ON UPDATE CASCADE,
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
    // sample data
    String sampleInsertDog = '''
      INSERT INTO $dogTABLE (url, imageName) VALUES
          ('https://example.com/dog1.jpg', 'dog1'),
          ('https://example.com/dog2.jpg', 'dog2'),
          ('https://example.com/dog3.jpg', 'dog3');
    ''';
    String sampleInsertBreed = '''
      INSERT INTO $breedTABLE (name, temperament) VALUES
          ('Breed1', 'Temperament1'),
          ('Breed2', 'Temperament2'),
          ('Breed3', 'Temperament3');
    ''';
    String sampleInsertSavedDog = '''
      INSERT INTO $savedDogTABLE (dogId, breedId) VALUES
          (1, 1),
          (1, 2),
          (2, 2),
          (2, 3),
          (3, 1),
          (3, 3);
    ''';
    await database.execute(sampleInsertDog);
    await database.execute(sampleInsertBreed);
    await database.execute(sampleInsertSavedDog);

    log("database initialized");
  }
}
