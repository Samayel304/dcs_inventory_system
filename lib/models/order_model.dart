import 'package:dcs_inventory_system/models/product_model.dart';

class Order {
  final String orderId;
  final Product products;
  final DateTime orderedDate;
  final int quantity;
  final String status;

  Order(
      {required this.orderId,
      required this.products,
      required this.orderedDate,
      required this.quantity,
      required this.status});

  static List<Order> orders = [
    Order(
        orderId: "1",
        products: Product.products.first,
        orderedDate: DateTime.now(),
        quantity: 1,
        status: "Pending")
  ];
}
