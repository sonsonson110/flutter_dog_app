import 'package:dog_app/src/model/dog.dart';
import 'package:dog_app/src/resource/dog_repository.dart';
import 'package:rxdart/rxdart.dart';

class DogBloc {
  final _repository = DogRepository();
  final _dogsFetcher = ReplaySubject<DogModel>();

  Stream<DogModel> get newDogNotifier => _dogsFetcher.stream;
  List<DogModel> get allDogs => _dogsFetcher.values;

  fetchAllDogs() async {
    List<DogModel> dogModel = await _repository.fetchAllDogs();
    for (final dog in dogModel) {
      _dogsFetcher.sink.add(dog);
    }
  }

  dispose() {
    _dogsFetcher.close();
  }
}

final bloc = DogBloc();
