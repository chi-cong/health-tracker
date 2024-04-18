import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const LoginPage(title: 'Health Tracker'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<LoginPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginPage> {
  final _loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Form(
          key: _loginKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        border: UnderlineInputBorder(),
                        labelText: 'Email'),
                    validator: (value) =>
                        value == null || value.trim().contains('@')
                            ? null
                            : 'Invalid Email',
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 250,
                  child: TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          border: UnderlineInputBorder(),
                          labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        RegExp regExp = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
                        if (value == null ||
                            value.length < 8 ||
                            value.length >= 30) {
                          return 'Password length should be 8 to 30';
                        }
                        if (!regExp.hasMatch(value)) {
                          return 'Must contains characters and digits';
                        }
                        return null;
                      }),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 150,
                  child: FilledButton(
                      onPressed: () {
                        if (_loginKey.currentState!.validate()) {}
                      },
                      child: const Text('Login')),
                )
              ],
            ),
          )),
    );
  }
}
