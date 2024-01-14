class DogEntity {
  int id;
  String url;
  String imageName;

  DogEntity({required this.id, required this.url, required this.imageName});

  factory DogEntity.fromMap(Map<String, dynamic> dogMap) {
    return DogEntity(
        id: dogMap["id"], url: dogMap["url"], imageName: dogMap["imageName"]);
  }

  Map<String, dynamic> toMap() {
    final dogMap = {
      "id": id,
      "url": url,
      "imageName": imageName,
    };
    return dogMap;
  }
}
