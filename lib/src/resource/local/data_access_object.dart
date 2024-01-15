// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:dog_app/src/model/dog.dart';
import 'package:dog_app/src/resource/local/database.dart';

class DogDAO {
  final dbProvider = DatabaseProvider.dbProvider;

  static const dogIdColumn = "dogId";
  static const dogUrlColumn = "url";
  static const dogImageNameColumn = "imageName";

  static const breedIdColumn = "breedId";
  static const breedNameColumn = "name";
  static const breedTemperamentColumn = "temperament";

  static const GET_ALL_DOGS_SQL = '''
    SELECT
        tblDog.id AS $dogIdColumn,
        tblDog.url AS $dogUrlColumn,
        tblDog.imageName AS $dogImageNameColumn,
        tblBreed.id AS $breedIdColumn,
        tblBreed.name AS $breedNameColumn,
        tblBreed.temperament AS $breedTemperamentColumn
    FROM
        tblDog
    JOIN
        tblSavedDog ON tblDog.id = tblSavedDog.dogId
    JOIN
        tblBreed ON tblSavedDog.breedId = tblBreed.id
  ''';

  // Add new dog record
  Future<int> createDog(DogModel dogModel) async {
    final db = await dbProvider.database;
    var result = db.insert(DatabaseProvider.dogTABLE,
        dogModel.toMap()); // this return id of new record
    log("record ${dogModel.id} to local database. returned id: $result");
    return result;
  }

  // Get all dogs
  Future<void> getFavouriteDogs() async {
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
  }
}
