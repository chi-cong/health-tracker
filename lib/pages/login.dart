import 'package:flutter/material.dart';
import 'signup.dart';
import './forgot_pass_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginKey = GlobalKey<FormState>();

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
        body: Form(
            key: _loginKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                            height: 10,
                          ),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPassPage()));
                                  },
                                  child: const Text("Forgot password"))
                            ],
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 250,
                    child: FilledButton(
                        onPressed: () {
                          if (_loginKey.currentState!.validate()) {}
                        },
                        child: const Text('Login')),
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Dont't have account ?"),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupPage()));
                            },
                            child: const Text('Signup'))
                      ],
                    ),
                  )
                ],
              ),
            )),
      )
    ]);
  }
}
