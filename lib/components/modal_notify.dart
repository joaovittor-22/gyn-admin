import 'dart:async';

import 'package:flutter/material.dart';


showConfirmMessage(BuildContext context, String title, String message, StreamController response) {

  // set up the button
  Widget okButton = TextButton(
    child: const Text("Sim"),
    onPressed: () {
      response.sink.add(true);
      Navigator.of(context).pop();
     },
  );
  Widget backButton = TextButton(
    child: const Text("Voltar"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
      backButton
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}