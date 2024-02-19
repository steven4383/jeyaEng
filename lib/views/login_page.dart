import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Controllers/auth_controller.dart';
import '../widgets/utilities.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/LoginPage';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;
  bool forgotPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.cover,
              )),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: getHeight(context) * 0.8, maxWidth: getWidth(context) / 3),
                  child: SingleChildScrollView(
                    child: Card(
                      color: Colors.white,
                      elevation: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: Image.asset('assets/jeyalogo.jpeg'),
                          ),
                          ListTile(title: const Text("Email"), subtitle: TextFormField(controller: emailController)),
                          forgotPassword
                              ? Container()
                              : ListTile(
                                  title: const Text("Password"),
                                  subtitle: TextFormField(
                                    controller: passwordController,
                                    obscureText: !showPassword,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                showPassword = !showPassword;
                                              });
                                            },
                                            icon: showPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off))),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: SizedBox(
                              height: 50,
                              width: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (forgotPassword) {
                                    auth.resetPassword(email: emailController.text.removeAllWhitespace).then((_) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Success"),
                                              content: const Text("An email will be sent, if the address is valid"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text("Okay"))
                                              ],
                                            );
                                          });
                                    });
                                  } else {
                                    auth.signInWithEmailAndPassword(emailController.text.removeAllWhitespace, passwordController.text).then((user) async {
                                      String result=await user!.getIdToken();

                                    });
                                  }
                                },
                                child: Text(forgotPassword ? "RESET PASSWORD" : "LOG IN"),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  forgotPassword = !forgotPassword;
                                });
                              },
                              child: Text(forgotPassword ? "Back to sign in" : "Forgot password ?"))
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
