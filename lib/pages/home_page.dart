import 'package:flutter/material.dart';
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
                  'Welcome Back ',
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
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white70),
                      color: Colors.white70,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
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
