import 'dart:async';
import 'dart:typed_data';
import 'package:app/blocs/list_cubit.dart';
import 'package:app/components/modal_notify.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'services/services.dart';
import './views/empty_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'views/add_place.dart';


Rx<Uint8List> image = Uint8List.fromList([]).obs;
Rx<String> imageUrl = "".obs;
Rx<String> imageName = "Adicionar imagem".obs;
XFile ? imageData;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: BlocProvider(
        create: (_) => ListCubit(),
        child: Scaffold(
          appBar: AppBar(title: const Text('Admin Gyn')),
          body: const MyHomePage(),
        ),
      ) );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    //  var width =   MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
            child: BlocBuilder<ListCubit,int>(
  builder: (context, state) {
     return FutureBuilder(
                future: Services().getList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done || BlocProvider.of<ListCubit>(context).state > 0) {
                    final List listPlaces = ((snapshot.data ?? []) as List);
                    return listPlaces.isNotEmpty
                        ? ListView.builder(
                            itemCount: listPlaces.length,
                            itemBuilder: (BuildContext context, int index) {
                              var isImageNull =
                                  listPlaces[index]['image'] == null;
                              return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: index + 1 != 10
                                                    ? const Color.fromARGB(
                                                        255, 228, 228, 228)
                                                    : Colors.transparent))),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          foregroundImage: !isImageNull
                                              ? NetworkImage(Services()
                                                  .getPlaceImageUrl(
                                                      listPlaces[index]
                                                          ['image']))
                                              : null,
                                          child: isImageNull
                                              ? const Text("Gyn")
                                              : null,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(listPlaces[index]['name']),
                                          ],
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  addPlace(context, "Editar",
                                                      listPlaces[index]['id']);
                                                },
                                                icon: const Icon(Icons.edit)),
                                            IconButton(
                                                onPressed: () {
                                                  StreamController<bool>
                                                      response =
                                                      StreamController();
                                                  response.stream.listen((choice) {
                                                    if (choice) {
                                                      Services().deletePlace(
                                                          listPlaces[index]
                                                              ['id']).then((_)=>{
                                                              BlocProvider.of<ListCubit>(context).update(),
                                                              });
                                                    } // apagar item
                                                  });
                                                  showConfirmMessage(
                                                      context,
                                                      "Atenção",
                                                      "Deseja exlcuir esse local?",
                                                      response);
                                                },
                                                icon: const Icon(Icons.delete)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ));
                            })
                        : emptyList();
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
  }
) ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              addPlace(context, "Cadastrar");
            },
            child: const Text('Cadastrar local')),
      ],
    );
  }
}