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
    log("Start fetching dog list from api...\n======");
    final response = await client.get(Uri.parse(
        "https://api.thedogapi.com/v1/images/search?api_key=$_apiKey&limit=$limit"));
    log("Response body: ${response.body}\n======");

    if (response.statusCode == 200) {
      // parse json if successfully fetched
      List l = json.decode(response.body);
      return l.map((e) => DogModel.fromJson(e)).toList();
    } else {
      // display error
      throw Exception("Failed to fetch - fetchDogList() \n======");
    }
  }
}
