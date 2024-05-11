import 'package:flutter/material.dart';
import '../auth/authentication.dart';
import './login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final Authentication authentication = Authentication();
  final _signupKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
          body: SingleChildScrollView(
            child: Form(
                key: _signupKey,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 200,
                      ),
                      SizedBox(
                          width: 250,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: emailController,
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
                                  controller: passwordController,
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.lock),
                                      border: UnderlineInputBorder(),
                                      labelText: 'Password'),
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
                                  controller: confirmPasswordController,
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.lock),
                                      border: UnderlineInputBorder(),
                                      labelText: 'Confirm Password'),
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
                                    if (passwordController.text !=
                                        confirmPasswordController.text) {
                                      return ('Must be the same with password');
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
                              if (_signupKey.currentState!.validate()) {
                                try {
                                  authentication.createUser(
                                      emailController.text,
                                      passwordController.text);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Signup Success ˶ᵔ ᵕ ᵔ˶'),
                                    duration: Durations.medium2,
                                  ));
                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        "Something gone wrong. Please try again (っ◞‸◟ c)"),
                                    duration: Durations.medium2,
                                  ));
                                }
                              }
                            },
                            child: const Text('Signup')),
                      ),
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account ?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
                                },
                                child: const Text('Login'))
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ))
    ]));
  }
}
