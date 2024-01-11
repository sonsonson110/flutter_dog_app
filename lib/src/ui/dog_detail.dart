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
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                dogData.breeds![0].name != null
                    ? "name: ${dogData.breeds![0].name}"
                    : "unknown",
                style: TextStyle(fontSize: FONT_NORMAL_SIZE),
              ),
              Text(
                dogData.breeds![0].bredFor != null
                    ? "bredFor: ${dogData.breeds![0].bredFor}"
                    : "unknown",
                style: TextStyle(fontSize: FONT_NORMAL_SIZE),
              ),
              Text(
                dogData.breeds![0].weight?.metric != null
                    ? "weight in metric: ${dogData.breeds![0].weight!.metric.toString()}kg"
                    : "unknown",
                style: TextStyle(fontSize: FONT_NORMAL_SIZE),
              ),
              Text(
                dogData.breeds![0].weight?.imperial != null
                    ? "weight in oz: ${dogData.breeds![0].weight!.imperial.toString()}oz"
                    : "unknown",
                style: TextStyle(fontSize: FONT_NORMAL_SIZE),
              ),
              Text(
                dogData.breeds![0].breedGroup != null
                    ? "breedGroup: ${dogData.breeds![0].breedGroup}"
                    : "unknown",
                style: TextStyle(fontSize: FONT_NORMAL_SIZE),
              ),
              Text(
                dogData.breeds![0].lifeSpan != null
                    ? "lifeSpan: ${dogData.breeds![0].lifeSpan}"
                    : "unknown",
                style: TextStyle(fontSize: FONT_NORMAL_SIZE),
              ),
              Text(
                dogData.breeds![0].temperament != null
                    ? "temperament: ${dogData.breeds![0].temperament}"
                    : "unknown",
                style: TextStyle(fontSize: FONT_NORMAL_SIZE),
              ),
            ])
          : Text(
              "Unknown data",
              style: TextStyle(fontSize: FONT_NORMAL_SIZE),
            ),
    );
  }

  DogFavourite() {
    return FilledButton(
      onPressed: () => bloc.sendDogFavourite(dogData.id!),
      child: StreamBuilder(
          stream: bloc.favouriteType,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: snapshot.data,
                  builder: (context, itemSnapshot) {
                    if (itemSnapshot.hasData) {
                      log("ui response data: ${itemSnapshot.data}");
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
