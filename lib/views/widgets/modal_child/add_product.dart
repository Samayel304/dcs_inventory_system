import 'package:dcs_inventory_system/models/product_model.dart';
import 'package:dcs_inventory_system/view_models/inventory_view_model.dart';
import 'package:dcs_inventory_system/views/widgets/custom_elevated_button.dart';
import 'package:dcs_inventory_system/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    Key? key,
    required this.category,
  }) : super(key: key);

  final int category;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Product", style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 20),
              CustomTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Product Name";
                  }
                  return null;
                },
                controller: productNameController,
                hintText: "Product Name",
              ),
              const SizedBox(height: 15),
              CustomTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Product Price";
                  }
                  return null;
                },
                controller: productPriceController,
                hintText: "Price",
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomElevatedButton(
                  text: "Save",
                  fontColor: Colors.white,
                  backgroundColor: Colors.black,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      switch (widget.category) {
                        case 0: //coffee
                          Product coffee = Product(
                              productId: (int.parse(inventoryViewModel
                                          .coffee.last.productId) +
                                      1)
                                  .toString(),
                              productName: productNameController.text,
                              quantity: 0,
                              category: "Coffee",
                              unitPrice:
                                  int.parse(productPriceController.text));
                          inventoryViewModel.addCoffee(coffee);
                          success();

                          break;
                        case 1: //milktea
                          Product milktea = Product(
                              productId: (int.parse(inventoryViewModel
                                          .milktea.last.productId) +
                                      1)
                                  .toString(),
                              productName: productNameController.text,
                              quantity: 0,
                              category: "Milktea",
                              unitPrice:
                                  int.parse(productPriceController.text));
                          inventoryViewModel.addMilktea(milktea);
                          success();
                          break;
                        case 2: //dimsum
                          Product dimsum = Product(
                              productId: (int.parse(inventoryViewModel
                                          .dimsum.last.productId) +
                                      1)
                                  .toString(),
                              productName: productNameController.text,
                              quantity: 0,
                              category: "Dimsum",
                              unitPrice:
                                  int.parse(productPriceController.text));
                          inventoryViewModel.addDimsum(dimsum);
                          success();
                          break;
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
