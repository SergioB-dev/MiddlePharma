import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseAuthentication() {
    isLoggedIn();
  }

  bool hasUserLoggedIn = false;

  Future<String?> createUser(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (kDebugMode) {
        print('✅ User with email: $email has been successfully created.');
      }
      hasUserLoggedIn = true;
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('❌ Could not create a user because $e');
      }
      return null;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (kDebugMode) {
        print('✅ User $email has successfully been signed in.');
      }
      hasUserLoggedIn = true;
      return credential.user?.uid;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ User $email failed to login. \nReason: $e');
      }
      return null;
    }
  }

  void isLoggedIn() {
    if (_firebaseAuth.currentUser == null) {
      hasUserLoggedIn = false;
    } else {
      hasUserLoggedIn = true;
    }
  }

  void logOut() {
    _firebaseAuth.signOut();
    hasUserLoggedIn = false;
    if (kDebugMode) {
      print('Logging out');
    }
  }
}
