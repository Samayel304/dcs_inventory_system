import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/custom_elevated_button.dart';
import 'package:dcs_inventory_system/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/enums.dart';

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

  //final _formKey = GlobalKey<FormState>();
  bool _canSave = false;

  @override
  void dispose() {
    productNameController.dispose();

    super.dispose();
  }

  void setCanSave() {
    if (productNameController.text.isNotEmpty) {
      setState(() {
        _canSave = true;
      });
    } else {
      setState(() {
        _canSave = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void addProduct(String category, BuildContext context) {
      int quantity = 0;
      Product product = Product(
          productName: productNameController.text,
          category: category,
          quantity: quantity,
          dateCreated: Timestamp.now().toDate());
      BlocProvider.of<ProductBloc>(context).add(AddProduct(product, context));
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
          //key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Product", style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 20),
              CustomTextField(
                onChange: (_) {
                  setCanSave();
                  //print(_formKey.currentState!.validate());
                },
                controller: productNameController,
                hintText: "Product Name",
              ),
              const SizedBox(height: 15),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomElevatedButton(
                    isDisable: !_canSave,
                    text: "Save",
                    fontColor: Colors.white,
                    backgroundColor: Colors.black,
                    onPressed: () {
                      switch (widget.category) {
                        case 0: //coffee

                          addProduct(ProductCategory.coffee.name, context);

                          break;
                        case 1: //milktea
                          addProduct(ProductCategory.milktea.name, context);

                          break;
                        case 2: //dimsum
                          addProduct(ProductCategory.dimsum.name, context);

                          break;
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
