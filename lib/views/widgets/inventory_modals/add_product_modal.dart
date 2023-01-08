import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/utils/constants.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:dcs_inventory_system/views/widgets/custom_elevated_button.dart';
import 'package:dcs_inventory_system/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddProductModal extends StatefulWidget {
  const AddProductModal({
    Key? key,
    required this.category,
  }) : super(key: key);

  final String category;

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController lifeSpanController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();
  //final _formKey = GlobalKey<FormState>();
  bool _canSave = false;
  File? _productImage;

  @override
  void dispose() {
    itemNameController.dispose();
    lifeSpanController.dispose();
    unitPriceController.dispose();
    super.dispose();
  }

  void setCanSave() {
    if (itemNameController.text.isNotEmpty &&
        lifeSpanController.text.isNotEmpty &&
        unitPriceController.text.isNotEmpty &&
        _productImage != null) {
      setState(() {
        _canSave = true;
      });
    } else {
      setState(() {
        _canSave = false;
      });
    }
  }

  void addItem(String category, BuildContext context) {
    int quantity = 0;
    Product product = Product(
        productName: itemNameController.text.toLowerCase(),
        category: category,
        quantity: quantity,
        dateCreated: Timestamp.now().toDate(),
        lifeSpan: lifeSpanController.text,
        unitPrice: double.parse(unitPriceController.text));
    BlocProvider.of<ProductBloc>(context)
        .add(AddProduct(product, _productImage!, context));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
            //key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Add Item", style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    CircleAvatar(
                        radius: (50),
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: _productImage == null
                              ? Image.network(Constant.defaultProductImageUrl)
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
                    //print(_formKey.currentState!.validate());
                  },
                  controller: itemNameController,
                  hintText: "Item Name",
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  onChange: (_) {
                    setCanSave();
                    //print(_formKey.currentState!.validate());
                  },
                  controller: unitPriceController,
                  hintText: "Unit Price",
                  textInputType: TextInputType.number,
                ),
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
                      isDisable: !_canSave,
                      text: "Save",
                      fontColor: Colors.white,
                      backgroundColor: Colors.black,
                      onPressed: () {
                        addItem(widget.category, context);
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
