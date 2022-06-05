import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:middle_pharamaceuticals/Models/product.dart';

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

class FirebaseFS {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference availableProducts =
      _firestore.collection('available_products');
  List<Product> allProducts = [];
  bool didLoadProducts = false;

  void getProduct() {
    if (kDebugMode) {
      print(_firestore.collection("products"));
    }
    _firestore
        .collection('products')
        .doc('uwvxegnxH0BaHQdGank1')
        .get()
        .then((response) {
      final data = response.data();
      print('Return type from firebase is $data');

      final product = Product(
          name: data!['name'],
          category: data['category'],
          description: data['description'],
          price: data['price']);
      print('We have a prodcut: \n $product');
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  void getProducts({required Function() callback}) {
    List<Product> results = [];
    _firestore
        .collection('available_products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        print(doc);
        results.add(Product(
            name: doc['name'],
            category: doc['category'],
            description: doc['description'],
            price: doc['price']));
      }
      allProducts = results;
      callback();
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    List<Product> products_by_category = [];
    final querySnapshot =
        await availableProducts.where('category', isEqualTo: category).get();
    for (final item in querySnapshot.docs) {
      final product = Product(
          name: item.get('name'),
          category: item.get('category'),
          description: item.get('description'),
          price: item.get('price'));
      products_by_category.add(product);
    }
    if (products_by_category.length == 0) {
      print('❌ Our async query for $category didnt return anything.');
    } else {
      print(
          '✅ Our async query for $category returned ${products_by_category.length} items.');
      print(products_by_category);
    }
    return products_by_category;
  }
  // Future<List<Product>?> getProductsX() async {
  //   List<Product> products = [];
  //   if (kDebugMode) {}
  //   final future_products = _firestore.collection('available_products').get();
  //   return future_products
  // }

}

class FirebaseClientStorage {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> downloadImage() async {
    final ref = _storage.ref().child('capsules/test.jpeg');
    var url = await ref.getDownloadURL();
    return url;
  }
}
