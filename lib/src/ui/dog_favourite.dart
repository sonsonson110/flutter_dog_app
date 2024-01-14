import 'dart:developer';

import 'package:dog_app/src/bloc/dog_favourite_bloc.dart';
import 'package:dog_app/src/bloc/dog_favourite_bloc_provider.dart';
import 'package:flutter/material.dart';

class DogFavourite extends StatefulWidget {
  const DogFavourite({super.key});

  @override
  State<DogFavourite> createState() => _DogFavouriteState();
}

class _DogFavouriteState extends State<DogFavourite> {
  late DogFavouriteBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = DogFavouriteBlocProvider.of(context);
    bloc.fetchFavouriteFromLocal();
    log("DogFavourite: bloc initialized");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back),
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
