import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../ViewModels/FirebaseManager.dart';
import '../firebase_options.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LoginScreenWidget extends StatelessWidget {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  Function userHasLoggedIn;
  LoginScreenWidget(this.userHasLoggedIn, {Key? key}) : super(key: key);

  FirebaseAuthentication auth = FirebaseAuthentication();

  void createUser() {
    auth
        .createUser(emailTextController.text, passwordTextController.text)
        .then((response) => {userHasLoggedIn()})
        // TODO: Handle errors
        .onError((error, stackTrace) => {});
  }

  void loginUser() {
    auth
        .login(emailTextController.text, passwordTextController.text)
        .then((response) => {userHasLoggedIn()})
        // TODO: Handle errors
        .onError((error, stackTrace) => {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: [
      const Text('Muhammad', style: TextStyle(fontSize: 20)),
      const Text('Pharmaceuticals', style: TextStyle(fontSize: 20)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: TextField(
            controller: emailTextController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'email'),
            style: const TextStyle(fontSize: 16)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: TextField(
            obscureText: true,
            controller: passwordTextController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'password'),
            style: const TextStyle(fontSize: 16)),
      ),
      ElevatedButton(onPressed: loginUser, child: const Text('Login'))
    ]);
  }
}
