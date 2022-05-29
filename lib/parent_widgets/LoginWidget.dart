import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../ViewModels/FirebaseManager.dart';
import '../firebase_options.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreenWidget> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  FirebaseAuthentication auth = FirebaseAuthentication();

  @override
  void dispose() {
    emailTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = FirebaseAuthentication();
  }

  Future<Response> getData() async {
    final String authority = 'www.googleapis.com';
    final String path = '/books/v1/volumes/junbDwAAQBAJ';
    Uri url = Uri.https(authority, path);
    return http.get(url);
  }

  Future<void> createUser() async {
    print(auth);
    var that = auth
        .createUser(emailTextController.text, passwordTextController.text)
        .then((response) => {print(response)})
        .catchError((e) => {print(e)});
    print(that);
  }

  bool isLoggedIn() {
    if (auth.firebaseAuth.currentUser == null) {
      return false;
    } else {
      return true;
    }
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
      ElevatedButton(
          onPressed: () {
            createUser();
          },
          child: isLoggedIn() ? const Text('Signup') : const Text('Login'))
    ]);
  }
}
