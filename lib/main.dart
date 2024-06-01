import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:loader_overlay/loader_overlay.dart";
import 'firebase_options.dart';
import 'pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoaderOverlay(child: LoginPage()),
    );
  }
}
