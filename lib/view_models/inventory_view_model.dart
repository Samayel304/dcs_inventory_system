import 'package:dcs_inventory_system/models/product_model.dart';
import 'package:flutter/cupertino.dart';

class InventoryViewModel extends ChangeNotifier {
  List<Product> _milktea = [];
  List<Product> _coffee = [];
  List<Product> _dimsum = [];

  List<Product> get milktea => _milktea;
  List<Product> get coffee => _coffee;
  List<Product> get dimsum => _dimsum;

  InventoryViewModel() {
    getMilktea();
    getDimsum();
    getCoffee();
  }

  setMilktea(List<Product> milktea) {
    _milktea = milktea;
    notifyListeners();
  }

  getMilktea() {
    var response = Product.milktea;
    setMilktea(response);
  }

  addMilktea(Product milktea) {
    // _milktea.add(value)
    _milktea.add(milktea);
    notifyListeners();
  }

  setCoffee(List<Product> coffee) {
    _coffee = coffee;
    notifyListeners();
  }

  getCoffee() {
    var response = Product.coffee;
    setMilktea(response);
  }

  addCoffee(Product coffee) {
    // _milktea.add(value)
    _coffee.add(coffee);
    notifyListeners();
  }

  setDimsum(List<Product> dimsum) {
    _dimsum = dimsum;
    notifyListeners();
  }

  getDimsum() {
    var response = Product.dimsum;
    setMilktea(response);
  }

  addDimsum(Product dimsum) {
    // _milktea.add(value)
    _dimsum.add(dimsum);
    notifyListeners();
  }
}
