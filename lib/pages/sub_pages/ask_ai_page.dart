import '../../env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
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
  List<BubbleSpecialThree> questionAnswers = [
    const BubbleSpecialThree(
      text: 'Hi, what can I help you ?',
      isSender: false,
    )
  ];
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: aiApiKey);

  Future<void> getAnswer(String prompt) async {
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    setState(() {
      questionAnswers.add(BubbleSpecialThree(
        text: response.text != null
            ? response.text!
            : "Failed to generate answer. Please try again",
        isSender: false,
      ));
    });
  }

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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Column(children: questionAnswers.map((e) => e).toList()),
              ),
            ),
            MessageBar(
              messageBarHintText: 'Type your question here',
              onSend: (prompt) => {
                setState(() {
                  questionAnswers.add(BubbleSpecialThree(
                    text: prompt,
                    color: Colors.blue,
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 16),
                  ));
                }),
                getAnswer(prompt)
              },
            ),
          ],
        ),
      ),
    ]);
  }
}
