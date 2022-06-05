class Product {
  String name;
  String category;
  String description;
  double price;
  String imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/mohamed-pharma.appspot.com/o/capsules%2Ftest.jpeg?alt=media&token=9c2b2faf-3eab-4bfa-bfaa-f3419ac9fd1f";

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
  });
}
