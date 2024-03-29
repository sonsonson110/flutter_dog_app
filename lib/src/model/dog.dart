class DogModel {
  List<Breeds>? breeds;
  String? id;
  String? url;
  int? width;
  int? height;

  DogModel({this.breeds, this.id, this.url, this.width, this.height});

  DogModel.fromJson(Map<String, dynamic> json) {
    if (json['breeds'] != null) {
      breeds = <Breeds>[];
      json['breeds'].forEach((v) {
        breeds!.add(Breeds.fromJson(v));
      });
    }
    id = json['id'];
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  DogModel.fromLocalDbMap(Map<String, dynamic> map) {
    id = map["id"];
    url = map["url"];
    breeds = map["breeds"];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (breeds != null) {
      data['breeds'] = breeds!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    return data;
  }

  Map<String, dynamic> toLocalDbMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["url"] = url;
    return data;
  }

  @override
  String toString() {
    return 'DogModel {\n'
        '  breeds: $breeds,\n'
        '  id: $id,\n'
        '  url: $url,\n'
        '  width: $width,\n'
        '  height: $height\n'
        '}';
  }
}

class Breeds {
  Weight? weight;
  Weight? height;
  int? id;
  String? name;
  String? bredFor;
  String? breedGroup;
  String? lifeSpan;
  String? temperament;
  String? referenceImageId;

  Breeds(
      {this.weight,
      this.height,
      this.id,
      this.name,
      this.bredFor,
      this.breedGroup,
      this.lifeSpan,
      this.temperament,
      this.referenceImageId});

  Breeds.fromJson(Map<String, dynamic> json) {
    weight = json['weight'] != null ? Weight.fromJson(json['weight']) : null;
    height = json['height'] != null ? Weight.fromJson(json['height']) : null;
    id = json['id'];
    name = json['name'];
    bredFor = json['bred_for'];
    breedGroup = json['breed_group'];
    lifeSpan = json['life_span'];
    temperament = json['temperament'];
    referenceImageId = json['reference_image_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (weight != null) {
      data['weight'] = weight!.toJson();
    }
    if (height != null) {
      data['height'] = height!.toJson();
    }
    data['id'] = id;
    data['name'] = name;
    data['bred_for'] = bredFor;
    data['breed_group'] = breedGroup;
    data['life_span'] = lifeSpan;
    data['temperament'] = temperament;
    data['reference_image_id'] = referenceImageId;
    return data;
  }

  Map<String, dynamic> toLocalDbMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["temperament"] = temperament;
    return data;
  }

  @override
  String toString() {
    return 'Breeds {\n'
        '  weight: $weight,\n'
        '  height: $height,\n'
        '  id: $id,\n'
        '  name: $name,\n'
        '  bredFor: $bredFor,\n'
        '  breedGroup: $breedGroup,\n'
        '  lifeSpan: $lifeSpan,\n'
        '  temperament: $temperament,\n'
        '  referenceImageId: $referenceImageId\n'
        '}';
  }
}

class Weight {
  String? imperial;
  String? metric;

  Weight({this.imperial, this.metric});

  Weight.fromJson(Map<String, dynamic> json) {
    imperial = json['imperial'];
    metric = json['metric'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imperial'] = imperial;
    data['metric'] = metric;
    return data;
  }

  @override
  String toString() {
    return 'Weight {\n'
        '  imperial: $imperial,\n'
        '  metric: $metric\n'
        '}';
  }
}
