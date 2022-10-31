import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/custom_elevated_button.dart';
import 'package:dcs_inventory_system/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/constant.dart';

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

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    productNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void addProduct(String category) {
      int quantity = 0;
      Product product = Product(
          productName: productNameController.text,
          category: category,
          quantity: quantity,
          dateCreated: Timestamp.now().toDate());
      BlocProvider.of<ProductBloc>(context).add(AddProduct(product));

      productNameController.clear();
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

                            addProduct(ProductCategory.coffee.name);

                            break;
                          case 1: //milktea
                            addProduct(ProductCategory.milktea.name);

                            break;
                          case 2: //dimsum
                            addProduct(ProductCategory.dimsum.name);

                            break;
                        }
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
