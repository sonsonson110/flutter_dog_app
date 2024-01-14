import 'package:dog_app/src/bloc/dog_favourite_bloc.dart';
import 'package:flutter/material.dart';

class DogFavouriteBlocProvider extends InheritedWidget {
  final DogFavouriteBloc bloc;

  DogFavouriteBlocProvider({super.key, required super.child})
      : bloc = DogFavouriteBloc();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static DogFavouriteBloc of(BuildContext context) {
    return (context.getInheritedWidgetOfExactType<DogFavouriteBlocProvider>()
            as DogFavouriteBlocProvider)
        .bloc;
  }
}
