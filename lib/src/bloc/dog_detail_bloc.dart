import 'dart:async';
import 'dart:developer';

import 'package:dog_app/src/resource/dog_repository.dart';
import 'package:rxdart/rxdart.dart';

class DogDetailBloc {
  final _repository = DogRepository();
  final _imageId = PublishSubject<String>();
  final _favouriteType = BehaviorSubject<Future<bool>>();

  void fetchDogFavouriteById(String imageId) {
    _imageId.sink.add;
    final isFavourited = _repository.getDogFavouriteById(imageId);
    _favouriteType.add(isFavourited);
  }

  Stream<Future<bool>> get favouriteType => _favouriteType.stream;

  Future<bool> initFuture() async {
    return false;
  }

  void sendDogFavourite(String imageId) {
    final updatedFavourite = _repository.sendDogFavourite(imageId);
    _favouriteType.sink.add(updatedFavourite);
  }

  void dispose() async {
    _imageId.close();
    await _favouriteType.drain();
    _favouriteType.close();
  }
}
