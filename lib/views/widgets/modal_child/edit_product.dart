import 'package:dcs_inventory_system/models/product_model.dart';
import 'package:dcs_inventory_system/view_models/inventory_view_model.dart';
import 'package:dcs_inventory_system/views/widgets/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatelessWidget {
  const EditProduct({
    Key? key,
    required this.productNameController,
    required this.productPriceController,
    required this.category,
    required this.selectedProduct,
  }) : super(key: key);

  final TextEditingController productNameController;
  final TextEditingController productPriceController;

  final int category;
  final Product selectedProduct;

  @override
  Widget build(BuildContext context) {
    void success() {
      productNameController.clear();
      productPriceController.clear();
      Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey.shade200,
          textColor: Colors.black,
          fontSize: 12.0);
      Navigator.pop(context);
    }

    InventoryViewModel inventoryViewModel = context.watch<InventoryViewModel>();
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Edit Product", style: Theme.of(context).textTheme.headline4),
            const SizedBox(height: 20),
            CustomTextField(
                hintText: selectedProduct.productName,
                controller: productNameController),
            const SizedBox(height: 15),
            CustomTextField(
                hintText: selectedProduct.unitPrice.toString(),
                textInputType: TextInputType.number,
                controller: productPriceController),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                onPressed: () {
                  switch (category) {
                    case 0: //coffee
                      inventoryViewModel.editCoffee(
                          selectedProduct.productId,
                          productNameController.text,
                          int.parse(productPriceController.text));
                      success();
                      break;
                    case 1: //milktea
                      inventoryViewModel.editMilktea(
                          selectedProduct.productId,
                          productNameController.text,
                          int.parse(productPriceController.text));
                      success();
                      break;
                    case 2:
                      inventoryViewModel.editDimsum(
                          selectedProduct.productId,
                          productNameController.text,
                          int.parse(productPriceController.text));
                      success();
                      break;
                  }
                },
                child: const Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
