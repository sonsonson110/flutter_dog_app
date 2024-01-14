import 'package:dog_app/src/model/dog.dart';
import 'package:dog_app/src/resource/dog_repository.dart';
import 'package:rxdart/rxdart.dart';

class DogFavouriteBloc {
  final _repository = DogRepository();
  final _favouriteDogList = PublishSubject<DogModel>();

  Stream<DogModel> get allDogFavourites => _favouriteDogList.stream;

  fetchFavouriteFromLocal() async {
    await _repository.getLocalFavouriteDogs();
  }
}
