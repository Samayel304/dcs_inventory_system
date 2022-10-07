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

  editMilktea(String producId, String producName, int unitPrice) {
    Product milktea =
        _milktea.firstWhere((milktea) => milktea.productId == producId);
    milktea.productName = producName;
    milktea.unitPrice = unitPrice;
    notifyListeners();
  }

  setCoffee(List<Product> coffee) {
    _coffee = coffee;
    notifyListeners();
  }

  getCoffee() {
    var response = Product.coffee;
    setCoffee(response);
  }

  addCoffee(Product coffee) {
    // _milktea.add(value)
    _coffee.add(coffee);
    notifyListeners();
  }

  editCoffee(String producId, String producName, int unitPrice) {
    Product coffee =
        _coffee.firstWhere((coffee) => coffee.productId == producId);
    coffee.productName = producName;
    coffee.unitPrice = unitPrice;
    notifyListeners();
  }

  setDimsum(List<Product> dimsum) {
    _dimsum = dimsum;
    notifyListeners();
  }

  getDimsum() {
    var response = Product.dimsum;
    setDimsum(response);
  }

  addDimsum(Product dimsum) {
    // _milktea.add(value)
    _dimsum.add(dimsum);
    notifyListeners();
  }

  editDimsum(String producId, String producName, int unitPrice) {
    Product dimsum =
        _dimsum.firstWhere((dimsum) => dimsum.productId == producId);
    dimsum.productName = producName;
    dimsum.unitPrice = unitPrice;
    notifyListeners();
  }
}
