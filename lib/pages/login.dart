import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../auth/authentication.dart';
import 'signup.dart';
import './forgot_pass_page.dart';
import './home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Authentication _authentication = Authentication();
  final _loginKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
          child: Form(
              key: _loginKey,
              child: Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 250,
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
                          onPressed: () async {
                            if (_loginKey.currentState!.validate()) {
                              context.loaderOverlay.show();
                              try {
                                var credential = await _authentication.loggin(
                                    emailController.text,
                                    passwordController.text);
                                if (credential != null && context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(e.toString()),
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              }
                              if (context.mounted) context.loaderOverlay.hide();
                            }
                          },
                          child: const Text('Login')),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Dont't have an account ?"),
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
        ),
      )
    ]);
  }
}
