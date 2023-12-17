import 'package:flutter/material.dart';

emptyList(){
  return const Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.playlist_remove,
        size: 36,
      ),
      SizedBox(height: 15,),
      Text("Lista Vazia")
    ],
  ));
}