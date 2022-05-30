import 'package:flutter/material.dart';
import 'package:middle_pharamaceuticals/ViewModels/FirebaseManager.dart';

import '../Models/Product.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  FirebaseFS firestore = FirebaseFS();
  late List<Product> products;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestore.getProducts(callback: () {
      setState(() {
        products = firestore.allProducts;
        print('We got the products!');
        print(products);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
