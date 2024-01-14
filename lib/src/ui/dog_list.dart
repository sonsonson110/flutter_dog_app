import 'dart:developer';

import 'package:dog_app/src/bloc/dog_bloc.dart';
import 'package:dog_app/src/bloc/dog_detail_bloc_provider.dart';
import 'package:dog_app/src/bloc/dog_favourite_bloc_provider.dart';
import 'package:dog_app/src/model/dog.dart';
import 'package:dog_app/src/ui/dog_detail.dart';
import 'package:dog_app/src/ui/dog_favourite.dart';
import 'package:flutter/material.dart';

class DogList extends StatefulWidget {
  const DogList({super.key});

  @override
  State<DogList> createState() => _DogListState();
}

class _DogListState extends State<DogList> {
  final _scrollController = ScrollController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    bloc.fetchAllDogs();

    _scrollController.addListener(() {
      if (isLoading) return;
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          log("DogList ui: at top");
        } else {
          log("DogList ui: at bottom");
          bloc.fetchAllDogs();
          isLoading = true;
        }
      }
    });
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
        title: const Text("Your daily doge app"),
        actions: [
          IconButton(
              onPressed: openFavouritedPage,
              icon: const Icon(
                Icons.favorite,
                color: Colors.black,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: bloc.newDogNotifier,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            isLoading = false;
            log("streamBuilder invoked");
            return buildList();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget buildList() {
    final dogs = bloc.allDogs;
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return dogs[index].url != null
            ? GestureDetector(
                child: Image.network(
                  dogs[index].url!,
                  fit: BoxFit.cover,
                ),
                onTap: () => openDetailPage(dogs[index]),
              )
            : const Text("fail to load");
      },
      itemCount: dogs.length,
    );
  }

  // add navigator
  openDetailPage(DogModel data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DogDetailBlocProvider(
        child: DogDetail(
          dogData: data,
        ),
      );
    }));
  }

  openFavouritedPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DogFavouriteBlocProvider(child: const DogFavourite());
    }));
  }
}
