import 'package:dog_app/src/model/dog.dart';
import 'package:dog_app/src/datasource/dog_repository.dart';
import 'package:rxdart/rxdart.dart';

class DogFavouriteBloc {
  final _repository = DogRepository();
  final _favouriteDogList = ReplaySubject<DogModel>();

  Stream<DogModel> get notify => _favouriteDogList.stream;
  List<DogModel> get allDogFavourites => _favouriteDogList.values;

  fetchFavouriteFromLocal() async {
    final favouriteDogs = await _repository.getLocalFavouriteDogs();
    for (var element in favouriteDogs) {
      _favouriteDogList.add(element);
    }
  }
}
