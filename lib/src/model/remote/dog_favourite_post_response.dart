// ignore_for_file: unnecessary_new

class DogFavouritePostResponse {
  String? message;
  int? id;

  DogFavouritePostResponse({this.message, this.id});

  DogFavouritePostResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = message;
    data['id'] = id;
    return data;
  }
}
