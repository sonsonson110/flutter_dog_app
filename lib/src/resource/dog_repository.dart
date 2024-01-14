import 'package:dog_app/src/model/dog.dart';
import 'package:dog_app/src/model/remote/dog_favourite_get_response.dart';
import 'package:dog_app/src/model/remote/dog_favourite_post_response.dart';
import 'package:dog_app/src/resource/local/data_access_object.dart';
import 'package:dog_app/src/resource/remote/dog_api_provider.dart';

class DogRepository {
  final _dogApiProvider = DogApiProvider();
  final _dogDAO = DogDAO();

  Future<List<DogModel>> fetchAllDogs() => _dogApiProvider.fetchDogList();

  Future<DogFavouritePostResponse?> sendDogFavourite(String imageId) =>
      _dogApiProvider.sendDogFavourite(imageId);

  Future<List<DogFavouriteGetResponse>?> getDogFavouriteByImageId(
          String imageId) =>
      _dogApiProvider.fetchDogFavouriteByImageId(imageId);

  Future<bool> sendDogUnfavourite(int favouriteId) =>
      _dogApiProvider.sendDogUnfavourite(favouriteId);

  Future<void> getLocalFavouriteDogs() => _dogDAO.getFavouriteDogs();
}
