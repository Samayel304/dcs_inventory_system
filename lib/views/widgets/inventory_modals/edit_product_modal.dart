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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    productNameController.text = widget.selectedProduct.productName;
  }

  @override
  void dispose() {
    productNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void success() {
      productNameController.clear();

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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomElevatedButton(
                  backgroundColor: Colors.black,
                  fontColor: Colors.white,
                  text: "Save",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Product editedProduct = widget.selectedProduct
                          .copyWith(productName: productNameController.text);
                      if (widget.selectedProduct.productName ==
                          productNameController.text) {
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
