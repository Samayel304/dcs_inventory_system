class Product {
  final String productId;
  final String productName;
  final int quantity;
  final String category;
  final int unitPrice;

  Product(
      {required this.productId,
      required this.productName,
      required this.quantity,
      required this.category,
      required this.unitPrice});

  static List<Product> products = [
    Product(
        productId: '1',
        productName: 'Vanilla',
        quantity: 2,
        category: "Milktea",
        unitPrice: 1000),
    Product(
        productId: '1',
        productName: 'Dimsum',
        quantity: 2,
        category: "Dimsum",
        unitPrice: 100),
    Product(
        productId: '1',
        productName: 'Coffee',
        quantity: 2,
        category: "Coffee",
        unitPrice: 300)
  ];

  static List<Product> milktea =
      products.where((product) => product.category == "Milktea").toList();

  static List<Product> coffee =
      products.where((product) => product.category == "Coffee").toList();

  static List<Product> dimsum =
      products.where((product) => product.category == "Dimsum").toList();
}
