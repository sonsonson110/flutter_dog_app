import 'package:dog_app/src/bloc/dog_bloc.dart';
import 'package:dog_app/src/bloc/dog_detail_bloc_provider.dart';
import 'package:dog_app/src/model/dog.dart';
import 'package:dog_app/src/ui/dog_detail.dart';
import 'package:flutter/material.dart';

class DogList extends StatefulWidget {
  const DogList({super.key});

  @override
  State<DogList> createState() => _DogListState();
}

class _DogListState extends State<DogList> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllDogs();
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
            ? GestureDetector(
                child: Image.network(
                  snapshot.data![index].url!,
                  fit: BoxFit.cover,
                ),
                onTap: () => openDetailPage(snapshot.data![index], index),
              )
            : const Text("fail to load");
      },
      itemCount: snapshot.data!.length,
    );
  }

  // add navigator
  openDetailPage(DogModel data, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      // return DogDetail(
      //   dogData: data,
      // );
      return DogDetailBlocProvider(
        child: DogDetail(
          dogData: data,
        ),
      );
    }));
  }
}
