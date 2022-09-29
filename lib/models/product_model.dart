class Product {
  final String productId;
  final String productName;
  final int quantity;
  final String category;

  Product(
      {required this.productId,
      required this.productName,
      required this.quantity,
      required this.category});

  static List<Product> products = [
    Product(
        productId: '1',
        productName: 'Vanilla',
        quantity: 2,
        category: "Milktea"),
    Product(
        productId: '1',
        productName: 'Vanilla',
        quantity: 2,
        category: "Milktea"),
    Product(
        productId: '1', productName: 'Vanilla', quantity: 2, category: "Coffee")
  ];
}
