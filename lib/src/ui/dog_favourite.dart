import 'dart:developer';
import 'dart:typed_data';

import 'package:dog_app/src/bloc/dog_favourite_bloc.dart';
import 'package:dog_app/src/bloc/dog_favourite_bloc_provider.dart';
import 'package:dog_app/src/model/dog.dart';
import 'package:dog_app/utils/image_utils.dart';
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
      body: dogFavouriteList(),
    );
  }

  dogFavouriteList() {
    return StreamBuilder(
        stream: bloc.notify,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildList(bloc.allDogFavourites);
          } else if (snapshot.hasError) {
            return const Text("Something wrong");
          }

          return const CircularProgressIndicator();
        });
  }

  buildList(List<DogModel> itemList) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Column(
          children: [
            DogImage(itemList[index].id!),
            Text(itemList[index].toString()),
          ],
        );
      },
      itemCount: itemList.length,
    );
  }

  DogImage(String imageName) {
    final futureImage = ImageUtils.getImageFromLocal(imageName);
    return FutureBuilder(
        future: futureImage,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            Uint8List imageBytes = snapshot.data!;
            return Image.memory(imageBytes);
          } else if (snapshot.hasError) {
            return const Text("Fail to load image from storage");
          }
          return const CircularProgressIndicator();
        }));
  }
}
