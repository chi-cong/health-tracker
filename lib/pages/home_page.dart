import 'package:flutter/material.dart';
import '../auth/authentication.dart';
import 'package:loader_overlay/loader_overlay.dart';
import './login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Authentication _authentication = Authentication();

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
            child: Center(
              child: Column(
                children: [
                  const Text('Main Page'),
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                            duration: Durations.long1,
                            backgroundColor: Colors.red,
                          ));
                        }
                        context.loaderOverlay.hide();
                      },
                      child: const Text('Logout'))
                ],
              ),
            ),
          ))
    ]);
  }
}
