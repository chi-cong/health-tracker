import 'package:flutter/material.dart';

class CustomSnackbar {
  void error(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Durations.extralong4,
      backgroundColor: Colors.red,
    ));
  }

  void success(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Durations.extralong4,
      backgroundColor: Colors.green,
    ));
  }
}
