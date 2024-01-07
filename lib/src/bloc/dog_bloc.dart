import 'package:dog_app/src/model/dog.dart';
import 'package:dog_app/src/resource/dog_repository.dart';
import 'package:rxdart/rxdart.dart';

class DogBloc {
  final _repository = DogRepository();
  final _dogsFetcher = PublishSubject<List<DogModel>>();

  Stream<List<DogModel>> get allDogs => _dogsFetcher.stream;

  fetchAllDogs() async {
    List<DogModel> dogModel = await _repository.fetchAllDogs();
    _dogsFetcher.sink.add(dogModel);
  }

  dispose() {
    _dogsFetcher.close();
  }
}

final bloc = DogBloc();
