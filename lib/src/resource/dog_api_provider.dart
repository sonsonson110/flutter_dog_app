import 'dart:convert';

import 'package:dog_app/src/model/dog.dart';
import 'package:http/http.dart' show Client;
import 'dart:developer';

class DogApiProvider {
  Client client = Client();
  final limit = 5;
  final _apiKey =
      "live_iUNkkFkBaDe0YLw1Fylsx0gXKJNFplvPMazxEZXkM5htv5sieXFr6FG2pgpRT3PP";

  Future<List<DogModel>> fetchDogList() async {
    log("Start fetching dog list from network...\n======");
    final response = await client.get(Uri.parse(
        "https://api.thedogapi.com/v1/images/search?api_key=$_apiKey&limit=$limit"));
    log("Response body: ${response.body}\n======");

    if (response.statusCode == 200) {
      // parse json if successfully fetched
      List l = json.decode(response.body);
      return l.map((e) => DogModel.fromJson(e)).toList();
    } else {
      // display error
      log("Response: ${response.body}\n======");
      throw Exception("Failed to fetch - fetchDogList() \n======");
    }
  }

  Future<bool> fetchDogFavouriteById(String id) async {
    log("Start GET favourite for dog-id:$id from api...\n======");
    final response = await client.get(
        Uri.parse("https://api.thedogapi.com/v1/favourites?image_id=$id"),
        headers: {"x-api-key": _apiKey});

    if (response.statusCode == 200) {
      log("Successfully GET favourite for dog-id:$id from api...\n======");
      log("Response: ${response.body}\n======");
      List l = json.decode(response.body);
      return l.isNotEmpty;
    } else {
      // display error
      log("Response: ${response.body}\n======");
      return false;
    }
  }

  Future<bool> sendDogFavourite(String imageId) async {
    log("Start POST favourite for dog-id:$imageId from api...\n======");
    final response = await client.post(
        Uri.parse("https://api.thedogapi.com/v1/favourites"),
        headers: {"x-api-key": _apiKey, "Content-Type": "application/json"},
        body: json.encode({"image_id": imageId}));

    if (response.statusCode == 200) {
      log("Response: ${response.body}\n======");
      return true;
    } else {
      log("Response: ${response.body}\n======");
      return false;
    }
  }
}
