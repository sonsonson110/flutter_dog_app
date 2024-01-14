// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:dog_app/src/resource/local/database.dart';
import 'package:dog_app/src/resource/local/entity/dog.dart';

class DogDAO {
  final dbProvider = DatabaseProvider.dbProvider;

  static const GET_ALL_DOGS_SQL = '''
    SELECT
        tblDog.id AS dogId,
        tblDog.url AS dogUrl,
        tblDog.imageName AS dogImageName,
        GROUP_CONCAT(tblBreed.name) AS breedNames,
        GROUP_CONCAT(tblBreed.temperament) AS breedTemperaments
    FROM
        tblDog
    JOIN
        tblSavedDog ON tblDog.id = tblSavedDog.dogId
    JOIN
        tblBreed ON tblSavedDog.breedId = tblBreed.id
    GROUP BY
        tblDog.id, tblDog.url, tblDog.imageName;
  ''';

  // Add new dog record
  Future<int> createDog(DogEntity dogEntity) async {
    final db = await dbProvider.database;
    var result = db.insert(DatabaseProvider.dogTABLE,
        dogEntity.toMap()); // this return id of new record
    return result;
  }

  // Get all dogs
  Future<void> getFavouriteDogs() async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = await db.rawQuery(GET_ALL_DOGS_SQL);
    log("SQL result: $result");
  }
}
