import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirstLoginPage extends StatefulWidget {
  final String accMail;
  const FirstLoginPage({super.key, required this.accMail});

  @override
  State<FirstLoginPage> createState() => _FirstLoginPageState();
}

class _FirstLoginPageState extends State<FirstLoginPage> {
  final db = FirebaseFirestore.instance;
  // final _firstLoginKey = GlobalKey<FormState>();

  // controllers
  final usernameController = TextEditingController();
  String birthDay = '';
  bool gender = false;
  bool isAsian = true;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
          child: Image.asset(
        './assets/bg_img/bg1.jpg',
        fit: BoxFit.cover,
      )),
      const Scaffold(
          backgroundColor: Colors.transparent, body: SingleChildScrollView())
    ]);
  }
}
