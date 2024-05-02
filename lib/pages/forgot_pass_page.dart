import 'package:flutter/material.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final _forgotKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return (Stack(children: [
      Positioned.fill(
          child: Image.asset(
        './assets/bg_img/bg1.jpg',
        fit: BoxFit.cover,
      )),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Forgot Password'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _forgotKey,
              child: Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 150,
                    ),
                    SizedBox(
                        width: 250,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.mail),
                                  border: UnderlineInputBorder(),
                                  labelText: 'Email'),
                              validator: (value) =>
                                  value == null || value.trim().contains('@')
                                      ? null
                                      : 'Invalid Email',
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    border: UnderlineInputBorder(),
                                    labelText: 'New Password'),
                                obscureText: true,
                                validator: (value) {
                                  RegExp regExp =
                                      RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
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
                            const SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    border: UnderlineInputBorder(),
                                    labelText: 'New Password Again'),
                                obscureText: true,
                                validator: (value) {
                                  RegExp regExp =
                                      RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
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
                          ],
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 250,
                      child: FilledButton(
                          onPressed: () {
                            if (_forgotKey.currentState!.validate()) {}
                          },
                          child: const Text('Change Password')),
                    ),
                  ],
                ),
              )),
        ),
      )
    ]));
  }
}
