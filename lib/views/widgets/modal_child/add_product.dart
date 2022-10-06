import 'package:dcs_inventory_system/models/product_model.dart';
import 'package:dcs_inventory_system/view_models/inventory_view_model.dart';
import 'package:dcs_inventory_system/views/widgets/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({
    Key? key,
    required this.productNameController,
    required this.productPriceController,
    required this.category,
  }) : super(key: key);

  final TextEditingController productNameController;
  final TextEditingController productPriceController;
  final int category;

  @override
  Widget build(BuildContext context) {
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
            Text("Add Product", style: Theme.of(context).textTheme.headline4),
            const SizedBox(height: 20),
            CustomTextField(
              controller: productNameController,
              hintText: "Product Name",
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: productPriceController,
              hintText: "Price",
              textInputType: TextInputType.number,
            ),
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
                      Product coffee = Product(
                          productId: "12",
                          productName: productNameController.text,
                          quantity: 0,
                          category: "Coffee",
                          unitPrice: int.parse(productPriceController.text));
                      inventoryViewModel.addCoffee(coffee);
                      break;
                    case 1: //milktea
                      Product milktea = Product(
                          productId: "12",
                          productName: productNameController.text,
                          quantity: 0,
                          category: "Milktea",
                          unitPrice: int.parse(productPriceController.text));
                      inventoryViewModel.addMilktea(milktea);
                      break;
                    case 2: //dimsum
                      Product dimsum = Product(
                          productId: "12",
                          productName: productNameController.text,
                          quantity: 0,
                          category: "Dimsum",
                          unitPrice: int.parse(productPriceController.text));
                      inventoryViewModel.addDimsum(dimsum);
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
