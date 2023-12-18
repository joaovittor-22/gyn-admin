
import 'dart:typed_data';

import 'package:app/main.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


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
