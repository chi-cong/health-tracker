import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AskAiPage extends StatefulWidget {
  final String accMail;
  const AskAiPage({super.key, required this.accMail});

  @override
  State<AskAiPage> createState() => _AskAiState();
}

class _AskAiState extends State<AskAiPage> {
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
          child: Image.asset(
        './assets/bg_img/bg1.jpg',
        fit: BoxFit.cover,
      )),
      Scaffold(
        appBar: AppBar(
          title: const Text('Ask AI'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 80, 40, 200),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
            width: double.infinity,
            height: 550,
            decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
      ),
    ]);
  }
}
