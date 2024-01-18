// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:dog_app/src/model/dog.dart';
import 'package:dog_app/src/datasource/local/database.dart';
import 'package:sqflite/sqflite.dart';

class DogDAO {
  final dbProvider = DatabaseProvider.dbProvider;

  static const dogIdColumn = "dogId";
  static const dogUrlColumn = "url";

  static const breedIdColumn = "breedId";
  static const breedNameColumn = "name";
  static const breedTemperamentColumn = "temperament";

  static const GET_ALL_DOGS_SQL = '''
    SELECT
        tblDog.id AS $dogIdColumn,
        tblDog.url AS $dogUrlColumn,
        tblBreed.id AS $breedIdColumn,
        tblBreed.name AS $breedNameColumn,
        tblBreed.temperament AS $breedTemperamentColumn
    FROM
        tblDog
    LEFT OUTER JOIN
        tblSavedDog ON tblDog.id = tblSavedDog.dogId
    LEFT OUTER JOIN
        tblBreed ON tblSavedDog.breedId = tblBreed.id
  ''';

  // Add new dog record
  Future<void> createDog(DogModel dogModel) async {
    final db = await dbProvider.database;
    // add to dog table
    var dogResult = await db.insert(
        DatabaseProvider.dogTABLE, dogModel.toLocalDbMap(),
        conflictAlgorithm:
            ConflictAlgorithm.abort); // this return id of new record
    log("record ${dogModel.id} to dog table. returned id: $dogResult");

    // add each breed to breed table
    for (final breed in dogModel.breeds!) {
      var breedResult = await db.insert(
          DatabaseProvider.breedTABLE, breed.toLocalDbMap(),
          conflictAlgorithm: ConflictAlgorithm.abort);
      log("record ${breed.id} to breed table. returned id: $breedResult");

      // also add dog-breed relationship to external table
      var savedDogResult = await db.insert(DatabaseProvider.savedDogTABLE,
          {"dogId": dogModel.id, "breedId": breed.id},
          conflictAlgorithm: ConflictAlgorithm.abort);
      log("record ${breed.id} to saved dog table. returned id: $savedDogResult");
    }
  }

  // Get all dogs
  Future<List<DogModel>> getFavouriteDogs() async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = await db.rawQuery(GET_ALL_DOGS_SQL);
    log("SQL result: $result");

    // process sql result
    List<DogModel> dogList = [];
    for (var currentRecord in result) {
      final lastDog = dogList.isEmpty ? null : dogList[dogList.length - 1];
      if (lastDog == null || currentRecord[dogIdColumn] != lastDog.id) {
        dogList.add(DogModel(
            id: currentRecord[dogIdColumn],
            url: currentRecord[dogUrlColumn],
            breeds: [
              Breeds(
                  id: currentRecord[breedIdColumn],
                  name: currentRecord[breedNameColumn],
                  temperament: currentRecord[breedTemperamentColumn])
            ]));
      } else if (currentRecord[dogIdColumn] == lastDog.id) {
        lastDog.breeds!.add(Breeds(
            id: currentRecord[breedIdColumn],
            name: currentRecord[breedNameColumn],
            temperament: currentRecord[breedTemperamentColumn]));
      }
    }

    log("Processed DogModel list: $dogList");
    return dogList;
  }
}
