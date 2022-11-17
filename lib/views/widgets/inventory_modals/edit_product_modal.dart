import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';

import 'package:dcs_inventory_system/views/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  //final _formKey = GlobalKey<FormState>();
  bool _canSave = false;

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

  void setCanSave() {
    if (productNameController.text.isNotEmpty &&
        (productNameController.text.toLowerCase() !=
            widget.selectedProduct.productName.toLowerCase())) {
      setState(() {
        _canSave = true;
      });
    } else {
      setState(() {
        _canSave = false;
      });
    }
  }

  void save() {
    Product editedProduct = widget.selectedProduct
        .copyWith(productName: productNameController.text);

    BlocProvider.of<ProductBloc>(context)
        .add(EditProduct(editedProduct, context));
  }

  @override
  Widget build(BuildContext context) {
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
              Text("Edit Product",
                  style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 20),
              CustomTextField(
                  onChange: (_) {
                    setCanSave();
                  },
                  /*  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Product Name";
                    }
                    return null;
                  }, */
                  hintText: "Product Name",
                  controller: productNameController),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomElevatedButton(
                  backgroundColor: Colors.black,
                  fontColor: Colors.white,
                  isDisable: !_canSave,
                  text: "Save",
                  onPressed: () => save(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
