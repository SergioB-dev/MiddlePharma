import 'package:flutter/material.dart';
import 'package:middle_pharamaceuticals/ViewModels/firebase_manager.dart';

import '../Models/product.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  FirebaseFS firestore = FirebaseFS();
  List<Product> products = [];

  @override
  void initState() {
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
    return GridView.builder(
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        if (products.isEmpty) {
          return const CircularProgressIndicator();
        }
        return Container(
            color: Colors.blue,
            margin: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () async {
                print(await firestore.getProductsByCategory('syrups'));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetailWidget(
                            products[index].name,
                            products[index].description,
                            products[index].price)));
              },
            ));
      },
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150),
    );
  }
}

class ProductDetailWidget extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  const ProductDetailWidget(this.name, this.description, this.price, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(name)),
        body: Card(
            child: Center(
          child: Column(children: [
            Text(name),
            Text(description),
            Text(price.toString())
          ]),
        )));
  }
}
