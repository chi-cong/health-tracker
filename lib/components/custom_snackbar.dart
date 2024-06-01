import 'package:flutter/material.dart';

class CustomSnackbar {
  void error(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Durations.long1,
      backgroundColor: Colors.red,
    ));
  }
}
