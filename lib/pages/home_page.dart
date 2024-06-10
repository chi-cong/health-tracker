import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/authentication.dart';
import '../components/custom_snackbar.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final String accMail;

  const HomePage({super.key, required this.accMail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Authentication _authentication = Authentication();
  final db = FirebaseFirestore.instance;
  final message = CustomSnackbar();
  var accRef;
  var accDoc;

  @override
  void initState() {
    accRef = db.doc('user/${widget.accMail}');
    accRef.get().then((DocumentSnapshot doc) => setState(() {
          accDoc = doc.data();
        }));
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
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(40, 90, 40, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    '${accDoc != null && accDoc!.containsKey('username') ? accDoc!['username'] : widget.accMail}',
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: 50,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text('BMI: 27'),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                        child: Text('Classification: Overweight'),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 65,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Icon(
                            Icons.task_outlined,
                            size: 40,
                            color: Colors.indigo,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                          child: Text(
                            'Update Daily Stats',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 65,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Icon(
                            Icons.person_outlined,
                            size: 40,
                            color: Colors.indigo,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                          child: Text(
                            'My Information',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 65,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Icon(
                            Icons.bar_chart_outlined,
                            size: 40,
                            color: Colors.indigo,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                          child: Text(
                            'Stats History',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 65,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Icon(
                            Icons.schedule_outlined,
                            size: 40,
                            color: Colors.indigo,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                          child: Text(
                            'Schedulte & Diet',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 65,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Icon(
                            Icons.question_answer_outlined,
                            size: 40,
                            color: Colors.indigo,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                          child: Text(
                            'Ask AI Chatbot',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      context.loaderOverlay.show();
                      try {
                        _authentication.logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      } catch (e) {
                        message.error(e.toString(), context);
                      }
                      context.loaderOverlay.hide();
                    },
                    child: const Text('Logout'))
              ],
            ),
          ))
    ]);
  }
}
