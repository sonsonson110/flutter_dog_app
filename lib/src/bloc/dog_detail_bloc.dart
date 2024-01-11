import 'dart:async';
import 'dart:developer';

import 'package:dog_app/src/resource/dog_repository.dart';
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

  void sendDogFavourite(String imageId) {
    if (_favouriteId == null) {
      final fetch = _repository.sendDogFavourite(imageId);
      final updatedFavourite = fetch.then((response) {
        _favouriteId = response?.id;
        return response != null;
      });
      _favouriteType.sink.add(updatedFavourite);
    } else {
      _sendDogUnfavourite();
    }
  }

  void _sendDogUnfavourite() {
    if (_favouriteId == null) return;
    final fetch = _repository.sendDogUnfavourite(_favouriteId!);
    final Future<bool> updatedFavourite = fetch.then((value) => !value);
    _favouriteType.sink.add(updatedFavourite);
    _favouriteId = null;
  }

  void dispose() async {
    await _favouriteType.drain();
    _favouriteType.close();
  }
}
