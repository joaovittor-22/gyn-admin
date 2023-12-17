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

Rx<Uint8List> image = Uint8List.fromList([]).obs;
Rx<String> imageUrl = "".obs;
Rx<String> imageName = 'Adicionar imagem'.obs;

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
                                                  _addPlace(context, "Editar",
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
              _addPlace(context, "Cadastrar");
            },
            child: const Text('Cadastrar local')),
      ],
    );
  }
}

_addPlace(context, String typeAction, [int? idPlace]) async {
//se for editar  precisa buscar dados antes
  var namePlaceController = TextEditingController();
  var placeData =
      idPlace != null ? await Services().getPlaceData(idPlace) : null;
  if (placeData != null) {
    namePlaceController.value = TextEditingValue(text: placeData["name"]);
    imageUrl.value = placeData["image"] != null
        ? await Services().getPlaceImageUrl(placeData["image"])
        : "";
    imageName.value = placeData["image"] ?? "Escolha uma imagem";
  }
  var controllerBottom = showBottomSheet(
      context: context,
      builder: (ctx2) {
        return Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          color: const Color.fromARGB(255, 240, 240, 240),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "$typeAction local",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  )),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: namePlaceController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Nome do local")),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () async {
                    var imageBytes = await pickImage() ?? Uint16List.fromList([]);
                    image.value = imageBytes;
                    imageUrl.value = "";
                  },
                  child: Obx(
                    () => ListTile(
                      leading: decideImage(typeAction),
                      title: Text(imageName.value),
                    ),
                  )),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 35),
                  ),
                  onPressed: () {
                    //adicionar ou editar item
                    var obj = {
                      "name_place": namePlaceController.value.text,
                      "image_bytes":image.value.isNotEmpty ? image.value : null,
                      "image_name":imageName.value,
                      "image_mime_type": imageData?.mimeType ?? "image/jpg"
                    };
                    Services().addOrUpdatePlace(idPlace, obj).then((res)=>{
                       // chamar bloc para atualizar pagina
                        BlocProvider.of<ListCubit>(context).update(),
                        Navigator.of(context).pop()
                    });
                  },
                  child: Text(typeAction))
            ],
          ),
        );
      });

  controllerBottom.closed.then((value) => resetPickImage());
}

decideImage(String typeAction) {
  if (imageUrl.isNotEmpty && typeAction == "Editar") {
    return Image.network(imageUrl.value);
  } else if ((typeAction == "Cadastrar" || typeAction == "Editar") &&
      image.value.isNotEmpty) {
    return Image(
      fit: BoxFit.fill,
      image: MemoryImage(image.value),
      width: 80,
      height: 80,
    );
  } else {
    return const CircleAvatar(
      radius: 25,
      child: Text("gyn"),
    );
  }
}

pickImage() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    Uint8List bytes = await image!.readAsBytes();
    imageName.value = image.name;
    imageData = image;
    return bytes;
  } catch (e) {
    return Uint16List.fromList([]);
  }
}

resetPickImage() {
  imageName.value = "Adicionar imagem";
  image.value = Uint8List.fromList([]);
  imageData = XFile.fromData(Uint8List.fromList([])) ;
}
