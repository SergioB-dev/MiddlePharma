import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:middle_pharamaceuticals/ViewModels/FirebaseManager.dart';
import 'package:middle_pharamaceuticals/parent_widgets/HomeScreen.dart';
import 'package:middle_pharamaceuticals/parent_widgets/LoginWidget.dart';

class RouterScreenWidget extends StatefulWidget {
  RouterScreenWidget({Key? key}) : super(key: key);

  @override
  State<RouterScreenWidget> createState() => _RouterScreenWidgetState();
}

class _RouterScreenWidgetState extends State<RouterScreenWidget> {
  FirebaseAuthentication auth = FirebaseAuthentication();
  FirebaseFS firestore = FirebaseFS();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  updateParent() {
    setState(() {
      auth.hasUserLoggedIn = !auth.hasUserLoggedIn;
      print(auth.hasUserLoggedIn);
    });
  }

  userHasLoggedIn() {
    setState(() {
      auth.isLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Testing'), actions: [
          if (auth.hasUserLoggedIn)
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                  onTap: () => setState(() {
                        auth.logOut();
                      }),
                  child: const Text('Log Out')),
            )
        ]),
        body: Container(
            child: auth.hasUserLoggedIn
                ? const HomeScreenWidget()
                : LoginScreenWidget(userHasLoggedIn)));
  }
}

class TestWidget extends StatelessWidget {
  final Function login;
  const TestWidget(this.login, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: const Text('Tap me'),
        onPressed: () {
          login();
        },
      ),
    );
  }
}
