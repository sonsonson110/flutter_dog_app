import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:dog_app/src/datasource/dog_repository.dart';
import 'package:dog_app/src/model/dog.dart';
import 'package:dog_app/utils/image_utils.dart';
import 'package:rxdart/rxdart.dart';

class DogDetailBloc {
  final _repository = DogRepository();
  final _favouriteType = BehaviorSubject<Future<bool>>();
  int? _favouriteId;

  Stream<Future<bool>> get favouriteType => _favouriteType.stream;

  Future<bool> initFuture() async {
    return false;
  }

  void fetchDogFavouriteById(String imageId) {
    final favouriteData = _repository.getDogFavouriteByImageId(imageId);
    // convert to bool
    final Future<bool> fetchFavourite = favouriteData.then((response) {
      _favouriteId = response?[0].id;
      log(_favouriteId.toString());
      return response != null;
    });
    _favouriteType.sink.add(fetchFavourite);
  }

  void onDogFavourite(DogModel dogData, Uint8List? imageBytes) {
    if (_favouriteId == null) {
      _sendDogFavourite(dogData);
      _saveFavouriteDog(dogData, imageBytes);
    } else {
      _sendDogUnfavourite(dogData);
    }
  }

  void _sendDogFavourite(DogModel dogData) async {
    final fetch = _repository.sendDogFavourite(dogData.id!);
    final updatedFavourite = fetch.then((response) {
      _favouriteId = response?.id;
      return response != null;
    });
    _favouriteType.sink.add(updatedFavourite);
  }

  void _sendDogUnfavourite(DogModel dogData) {
    if (_favouriteId == null) return;
    final fetch = _repository.sendDogUnfavourite(_favouriteId!);
    final Future<bool> updatedFavourite = fetch.then((value) => !value);
    _favouriteType.sink.add(updatedFavourite);
    _favouriteId = null;
  }

  void _saveFavouriteDog(DogModel dogData, Uint8List? imageBytes) async {
    await _repository.saveDogToDatabase(dogData);
    if (imageBytes == null) return;
    ImageUtils.saveImageToLocal(imageBytes, dogData.id!);
  }

  void dispose() async {
    await _favouriteType.drain();
    _favouriteType.close();
  }
}
