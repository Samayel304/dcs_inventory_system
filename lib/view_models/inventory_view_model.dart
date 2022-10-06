import 'package:dcs_inventory_system/models/product_model.dart';
import 'package:flutter/cupertino.dart';

class InventoryViewModel extends ChangeNotifier {
  List<Product> _milktea = [];

  List<Product> get milktea => _milktea;

  setMilktea(List<Product> milktea) {
    _milktea = milktea;
    notifyListeners();
  }

  getMilktea() {
    var response = Product.milktea;
    setMilktea(response);
  }

  addMilktea() {
    // _milktea.add(value)
  }
}
