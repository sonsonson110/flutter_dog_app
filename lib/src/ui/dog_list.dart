import 'package:dog_app/src/bloc/dog_bloc.dart';
import 'package:dog_app/src/model/dog.dart';
import 'package:flutter/material.dart';

class DogList extends StatelessWidget {
  const DogList({super.key});

  @override
  Widget build(BuildContext context) {
    bloc.fetchAllDogs();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your favourite doggies app"),
      ),
      body: StreamBuilder(
        stream: bloc.allDogs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
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

  Widget buildList(AsyncSnapshot<List<DogModel>> snapshot) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return snapshot.data![index].url != null
            ? Image.network(
                snapshot.data![index].url!,
                fit: BoxFit.cover,
              )
            : const Text("fail to load");
      },
      itemCount: snapshot.data!.length,
    );
  }
}
