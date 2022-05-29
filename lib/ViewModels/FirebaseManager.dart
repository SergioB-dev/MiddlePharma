import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthentication {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String?> createUser(String email, String password) async {
    try {
      UserCredential credential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('❌ Could not create a user because $e');
      }
      return null;
    }
  }

  bool isLoggedIn() {
    if (firebaseAuth.currentUser == null) {
      return false;
    } else {
      print(firebaseAuth.currentUser?.uid);
      return true;
    }
  }
}
