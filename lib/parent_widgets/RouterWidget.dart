import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:middle_pharamaceuticals/ViewModels/FirebaseManager.dart';
import 'package:middle_pharamaceuticals/parent_widgets/LoginWidget.dart';

class RouterScreenWidget extends StatelessWidget {
  RouterScreenWidget({Key? key}) : super(key: key);
  FirebaseAuthentication auth = FirebaseAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Testing')),
        body: Container(
            child: auth.isLoggedIn()
                ? const Text('We are already logged in!')
                : const LoginScreenWidget()));
  }
}
