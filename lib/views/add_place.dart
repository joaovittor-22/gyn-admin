import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:app/main.dart';
import 'package:app/services/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/blocs/list_cubit.dart';
import 'package:get/get.dart';
import 'package:app/tools/images.dart';

addPlace(context, String typeAction, [int? idPlace]) async {
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
                    minimumSize: const Size(double.infinity, 55),
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