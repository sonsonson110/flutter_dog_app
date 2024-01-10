import 'package:dog_app/src/model/dog.dart';
import 'package:dog_app/src/resource/dog_api_provider.dart';

class DogRepository {
  final dogApiProvider = DogApiProvider();

  Future<List<DogModel>> fetchAllDogs() => dogApiProvider.fetchDogList();
  Future<bool> sendDogFavourite(String imageId) =>
      dogApiProvider.sendDogFavourite(imageId);
  Future<bool> getDogFavouriteById(String imageId) =>
      dogApiProvider.fetchDogFavouriteById(imageId);
}
