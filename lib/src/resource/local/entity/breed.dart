class BreedEntity {
  int id;
  String name;
  String? teperament;

  BreedEntity({required this.id, required this.name, this.teperament});

  factory BreedEntity.fromMap(Map<String, dynamic> breedMap) => BreedEntity(
      id: breedMap["id"],
      name: breedMap["name"],
      teperament: breedMap["teperament"]);

  Map<String, dynamic> toMap() =>
      {"id": id, "name": name, "temperament": teperament};
}
