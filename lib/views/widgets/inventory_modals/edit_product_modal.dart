import 'dart:io';

import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/utils/utils.dart';

import 'package:dcs_inventory_system/views/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
  TextEditingController lifeSpanController = TextEditingController();

  //final _formKey = GlobalKey<FormState>();
  bool _canSave = false;
  File? _productImage;
  @override
  void initState() {
    super.initState();

    productNameController.text = widget.selectedProduct.productName;
    lifeSpanController.text = widget.selectedProduct.lifeSpan;
  }

  @override
  void dispose() {
    productNameController.dispose();
    lifeSpanController.dispose();
    super.dispose();
  }

  void setCanSave() {
    bool isProductNameNotSame = productNameController.text.toLowerCase() !=
        widget.selectedProduct.productName.toLowerCase();
    bool isLifeSpanSame = lifeSpanController.text.toLowerCase() !=
        widget.selectedProduct.lifeSpan.toLowerCase();

    if (productNameController.text.isNotEmpty &&
        lifeSpanController.text.isNotEmpty &&
        (isProductNameNotSame || isLifeSpanSame || _productImage != null)) {
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
    Product editedProduct = widget.selectedProduct.copyWith(
        productName: productNameController.text.toLowerCase(),
        lifeSpan: lifeSpanController.text);

    BlocProvider.of<ProductBloc>(context)
        .add(EditProduct(editedProduct, _productImage, context));
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
              Stack(
                children: [
                  CircleAvatar(
                      radius: (50),
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: _productImage == null
                            ? Image.network(
                                widget.selectedProduct.productImageUrl)
                            : Image.file(_productImage!),
                      )),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 45,
                        height: 45,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.6)),
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            XFile? image = await getImage();
                            if (image != null) {
                              setState(() {
                                _productImage = File(image.path);
                              });
                              setCanSave();
                            }
                          },
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
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
              CustomTextField(
                onChange: (_) {
                  setCanSave();
                  //print(_formKey.currentState!.validate());
                },
                controller: lifeSpanController,
                hintText: "Life Span",
              ),
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
