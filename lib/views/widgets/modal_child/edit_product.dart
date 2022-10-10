import 'package:dcs_inventory_system/models/product_model.dart';
import 'package:dcs_inventory_system/view_models/inventory_view_model.dart';
import 'package:dcs_inventory_system/views/widgets/custom_elevated_button.dart';
import 'package:dcs_inventory_system/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({
    Key? key,
    required this.category,
    required this.selectedProduct,
  }) : super(key: key);

  final int category;
  final Product selectedProduct;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
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
              Text("Edit Product",
                  style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 20),
              CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Product Name";
                    }
                    return null;
                  },
                  hintText: widget.selectedProduct.productName,
                  controller: productNameController),
              const SizedBox(height: 15),
              CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Product Price";
                    }
                    return null;
                  },
                  hintText: widget.selectedProduct.unitPrice.toString(),
                  textInputType: TextInputType.number,
                  controller: productPriceController),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomElevatedButton(
                  backgroundColor: Colors.black,
                  fontColor: Colors.white,
                  text: "Save",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      switch (widget.category) {
                        case 0: //coffee
                          inventoryViewModel.editCoffee(
                              widget.selectedProduct.productId,
                              productNameController.text,
                              int.parse(productPriceController.text));
                          success();
                          break;
                        case 1: //milktea
                          inventoryViewModel.editMilktea(
                              widget.selectedProduct.productId,
                              productNameController.text,
                              int.parse(productPriceController.text));
                          success();
                          break;
                        case 2:
                          inventoryViewModel.editDimsum(
                              widget.selectedProduct.productId,
                              productNameController.text,
                              int.parse(productPriceController.text));
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
