import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/custom_elevated_button.dart';
import 'package:dcs_inventory_system/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddProductModal extends StatefulWidget {
  const AddProductModal({
    Key? key,
    required this.category,
  }) : super(key: key);

  final int category;

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
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

    void addProduct(String category) {
      int quantity = 0;
      Product product = Product(
          productName: productNameController.text,
          category: category,
          quantity: quantity,
          unitPrice: double.parse(productPriceController.text),
          dateCreated: Timestamp.now().toDate());
      context.read<ProductBloc>().add(AddProduct(product));
    }

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Add Product",
                      style: Theme.of(context).textTheme.headline4),
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
                              addProduct('Coffee');
                              success();
                              break;
                            case 1: //milktea
                              addProduct('Milktea');
                              success();
                              break;
                            case 2: //dimsum
                              addProduct('Dimsum');
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
      },
    );
  }
}
