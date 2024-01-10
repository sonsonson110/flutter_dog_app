import 'package:dog_app/src/bloc/dog_detail_bloc.dart';
import 'package:flutter/material.dart';

class DogDetailBlocProvider extends InheritedWidget {
  final DogDetailBloc bloc;

  DogDetailBlocProvider({super.key, required super.child})
      : bloc = DogDetailBloc();

  @override
  bool updateShouldNotify(oldWidget) {
    return true;
  }

  static DogDetailBloc of(BuildContext context) {
    return (context.getInheritedWidgetOfExactType<DogDetailBlocProvider>()
            as DogDetailBlocProvider)
        .bloc;
  }
}
