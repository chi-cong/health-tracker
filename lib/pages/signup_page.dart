import 'package:flutter/material.dart';
import '../auth/authentication.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final Authentication _authentication = Authentication();
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
            padding: const EdgeInsets.fromLTRB(40, 200, 40, 200),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
              width: double.infinity,
              height: 470,
              decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Form(
                  key: _signupKey,
                  child: Center(
                    child: Column(
                      children: <Widget>[
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
                                  validator: (value) => value == null ||
                                          value.trim().contains('@')
                                      ? null
                                      : 'Email không hợp lệ',
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                TextFormField(
                                    controller: passwordController,
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.lock),
                                        border: UnderlineInputBorder(),
                                        labelText: 'Mật khẩu'),
                                    obscureText: true,
                                    validator: (value) {
                                      RegExp regExp =
                                          RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
                                      if (value == null ||
                                          value.length < 8 ||
                                          value.length >= 30) {
                                        return 'Mật khẩu dài từ 8 đến 30 ký tự';
                                      }
                                      if (!regExp.hasMatch(value)) {
                                        return 'Phải chứa ký tự chữ và số';
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
                                        labelText: 'Xác nhận mật khẩu'),
                                    obscureText: true,
                                    validator: (value) {
                                      RegExp regExp =
                                          RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
                                      if (value == null ||
                                          value.length < 8 ||
                                          value.length >= 30) {
                                        return 'Mật khẩu dài từ 8 đến 30 ký tự';
                                      }
                                      if (!regExp.hasMatch(value)) {
                                        return 'Phải chứa ký tự chữ và số';
                                      }
                                      if (passwordController.text !=
                                          confirmPasswordController.text) {
                                        return ('Không khớp với mật khẩu');
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
                              onPressed: () async {
                                if (_signupKey.currentState!.validate()) {
                                  context.loaderOverlay.show();
                                  try {
                                    await _authentication.createUser(
                                        emailController.text,
                                        passwordController.text);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Đăng ký tài khoản thành công ˶ᵔ ᵕ ᵔ˶'),
                                        duration: Duration(milliseconds: 5000),
                                      ));
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(e.toString()),
                                        duration: Durations.long1,
                                        backgroundColor: Colors.red,
                                      ));
                                    }
                                  }
                                  if (context.mounted) {
                                    context.loaderOverlay.hide();
                                  }
                                }
                              },
                              child: const Text('Đăng ký')),
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Đã có tài khoản ?"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()));
                                  },
                                  child: const Text('Đăng nhập'))
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ))
    ]));
  }
}
