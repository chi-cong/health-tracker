import 'package:flutter/material.dart';
import '../auth/authentication.dart';
import '../components/custom_snackbar.dart';

import 'package:loader_overlay/loader_overlay.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final _forgotKey = GlobalKey<FormState>();
  final _authentication = Authentication();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
          child: Image.asset(
        './assets/bg_img/bg1.jpg',
        fit: BoxFit.cover,
      )),
      Scaffold(
        appBar: AppBar(
          title: const Text('Quên mật khẩu'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 200, 40, 200),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 70, 0, 50),
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Form(
                key: _forgotKey,
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
                                    labelText: 'Email của bạn'),
                                validator: (value) =>
                                    value == null || value.trim().contains('@')
                                        ? null
                                        : 'Email không hợp lệ',
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 250,
                        child: FilledButton(
                            onPressed: () async {
                              if (_forgotKey.currentState!.validate()) {
                                context.loaderOverlay.show();
                                try {
                                  await _authentication
                                      .resetPassword(emailController.text);
                                  if (context.mounted) {
                                    CustomSnackbar().success(
                                        "Xin hãy kiểm tra email của bạn",
                                        context);
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Đã có lỗi xảy ra, xin hãy thử lại"),
                                      duration: Duration(milliseconds: 5000),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                }
                                if (context.mounted) {
                                  context.loaderOverlay.hide();
                                }
                              }
                            },
                            child: const Text('Tạo lại mật khẩu')),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      )
    ]);
  }
}
