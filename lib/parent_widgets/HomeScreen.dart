import 'package:flutter/material.dart';
import 'package:middle_pharamaceuticals/view_models/firebase_manager.dart';

import '../Models/product.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  FirebaseFS firestore = FirebaseFS();
  List<Product> products = [];

  List<Category> currentCategories = [
    Category('capsules'),
    Category('tablets'),
    Category('syrups'),
    Category('cottons'),
    Category('tincture'),
    Category('creams'),
    Category('ointments'),
    Category('injection'),
    Category('iv fluids')
  ];

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
        itemCount: currentCategories.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 3, maxCrossAxisExtent: 200),
        itemBuilder: (ctx, index) {
          return Padding(
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                child: Container(
                    child: Center(child: Text(currentCategories[index].name)),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        shape: BoxShape.rectangle,
                        color: Colors.blue)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CategoryGroupScreen(currentCategories[index])));
                  print('$index');
                },
              ));
        });
  }
}

class CategoryGroupScreen extends StatefulWidget {
  CategoryGroupScreen(this.category, {Key? key}) : super(key: key);
  final Category category;

  @override
  State<CategoryGroupScreen> createState() =>
      _CategoryGroupScreenState(category);
}

class _CategoryGroupScreenState extends State<CategoryGroupScreen> {
  final FirebaseFS firestore = FirebaseFS();
  final Category category;
  late Future<List<Product>> products;

  _CategoryGroupScreenState(this.category);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    products = firestore.getProductsByCategory(category.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.category.name)),
        body: FutureBuilder(
            future: products,
            builder: (ctx, AsyncSnapshot<List<Product>> snapshot) {
              print(snapshot.connectionState);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  print('We are safe');
                  print(snapshot.data!.length);

                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (ctx, index) {
                      print(snapshot.data?.length ?? 0);
                      final product = snapshot.data![index];
                      print(product.name);
                      return ListTile(
                          onTap: () {
                            navigateToDetailScreen(product);
                          },
                          title: Text(product.name));
                    },
                  );
                }
                download();
                print('Dangeeer zone');
                return Text('No items currently for ${category.name}');
              }
              return Text('Nooo');
            }));
  }

  void navigateToDetailScreen(Product product) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProductDetailWidget(product)));
  }

  void download() {
    FirebaseClientStorage().downloadImage().then((res) {
      print(res);
    }).catchError((err, stack) {
      print(err);
    });
  }
}

class ProductDetailWidget extends StatelessWidget {
  final Product product;
  const ProductDetailWidget(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(product.name)),
        body: Card(
            child: Center(
          child: Column(children: [
            Text(product.name),
            Text(product.description),
            Text(product.price.toString()),
            Image.network(product.imageUrl)
          ]),
        )));
  }
}

class Category {
  final String name;

  Category(this.name);
}
