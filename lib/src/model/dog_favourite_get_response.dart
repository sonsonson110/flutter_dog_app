class DogFavouriteGetResponse {
  int? id;
  String? userId;
  String? imageId;
  String? subId;
  String? createdAt;
  Image? image;

  DogFavouriteGetResponse(
      {this.id,
      this.userId,
      this.imageId,
      this.subId,
      this.createdAt,
      this.image});

  DogFavouriteGetResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    imageId = json['image_id'];
    subId = json['sub_id'];
    createdAt = json['created_at'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['image_id'] = imageId;
    data['sub_id'] = subId;
    data['created_at'] = createdAt;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class Image {
  String? id;
  String? url;

  Image({this.id, this.url});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}
