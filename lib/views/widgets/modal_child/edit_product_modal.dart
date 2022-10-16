import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';

import 'package:dcs_inventory_system/views/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProductModal extends StatefulWidget {
  const EditProductModal({
    Key? key,
    required this.selectedProduct,
  }) : super(key: key);

  final Product selectedProduct;

  @override
  State<EditProductModal> createState() => _EditProductModalState();
}

class _EditProductModalState extends State<EditProductModal> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    productNameController.text = widget.selectedProduct.productName;
    productPriceController.text = widget.selectedProduct.unitPrice.toString();
  }

  @override
  void dispose() {
    productNameController.dispose();
    productPriceController.dispose();
    super.dispose();
  }

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
                  hintText: "Product Name",
                  controller: productNameController),
              const SizedBox(height: 15),
              CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Product Price";
                    }
                    return null;
                  },
                  hintText: "Product Price",
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
                      Product editedProduct = widget.selectedProduct.copyWith(
                          productName: productNameController.text,
                          unitPrice: double.parse(productPriceController.text));
                      if (widget.selectedProduct.productName ==
                              productNameController.text &&
                          widget.selectedProduct.unitPrice ==
                              double.parse(productPriceController.text)) {
                        success();
                      } else {
                        BlocProvider.of<ProductBloc>(context)
                            .add(EditProduct(editedProduct));
                        success();
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
