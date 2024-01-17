import 'dart:developer';

import 'package:dog_app/src/bloc/dog_detail_bloc.dart';
import 'package:dog_app/src/bloc/dog_detail_bloc_provider.dart';
import 'package:dog_app/src/model/dog.dart';
import 'package:flutter/material.dart';

class DogDetail extends StatefulWidget {
  final DogModel dogData;
  const DogDetail({super.key, required this.dogData});

  @override
  State<DogDetail> createState() => _DogDetailState(dogData: dogData);
}

class _DogDetailState extends State<DogDetail> {
  final DogModel dogData;
  late DogDetailBloc bloc;

  final FONT_TITLE_SIZE = 30.0;
  final FONT_NORMAL_SIZE = 16.0;

  _DogDetailState({required this.dogData});

  @override
  void didChangeDependencies() {
    bloc = DogDetailBlocProvider.of(context);
    bloc.fetchDogFavouriteById(dogData.id!);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back),
            onTap: () => Navigator.pop(context),
          ),
          title: const Text("Doge info"),
        ),
        body: SafeArea(
            top: true,
            bottom: false,
            child: ListView(
              children: <Widget>[
                Image.network(
                  dogData.url!,
                  fit: BoxFit.cover,
                ),
                DogFavourite(),
                DogInfo(),
              ],
            )));
  }

  DogInfo() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: dogData.breeds!.isNotEmpty
            ? Text(dogData.toString())
            : const Text("no data"));
  }

  DogFavourite() {
    return FilledButton(
      onPressed: () => bloc.onDogFavourite(dogData),
      child: StreamBuilder(
          stream: bloc.favouriteType,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: snapshot.data,
                  builder: (context, itemSnapshot) {
                    if (itemSnapshot.hasData) {
                      return Text(
                          itemSnapshot.data! == false ? "Like" : "Liked");
                    } else if (itemSnapshot.hasError) {
                      log(itemSnapshot.error.toString());
                      return const Text("Something wrong :(");
                    }

                    return const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  });
            } else {
              return Text(snapshot.error.toString());
            }
          }),
    );
  }
}
