class SavedDogEntity {
  int id;
  int dogId;
  int breedId;

  SavedDogEntity(
      {required this.id, required this.dogId, required this.breedId});

  factory SavedDogEntity.fromMap(Map<String, dynamic> map) {
    return SavedDogEntity(
        id: map["id"], dogId: map["dogId"], breedId: map["breedId"]);
  }

  toMap() => {
        "id": id,
        "dogId": dogId,
        "breedId": breedId,
      };
}
