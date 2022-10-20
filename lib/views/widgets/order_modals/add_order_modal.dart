import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/utils/constant.dart';
import 'package:dcs_inventory_system/views/widgets/custom_dropdown.dart';
import 'package:dcs_inventory_system/views/widgets/custom_elevated_button.dart';
import 'package:dcs_inventory_system/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddOrderModal extends StatefulWidget {
  const AddOrderModal({
    Key? key,
    required this.products,
  }) : super(key: key);
  final List<Product> products;
  @override
  State<AddOrderModal> createState() => _AddOrderModalState();
}

class _AddOrderModalState extends State<AddOrderModal> {
  TextEditingController productQuantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late Product _selectedProduct;

  @override
  void initState() {
    super.initState();
    _selectedProduct = widget.products.first;
  }

  @override
  void dispose() {
    productQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void success() {
      productQuantityController.clear();

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
              Text("Add Order", style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 20),
              CustomDropdown(
                value: _selectedProduct,
                hint: const Text("Select product."),
                validator: (value) {
                  if (value == null) {
                    return "Please Select product.";
                  }
                  return null;
                },
                onChange: (value) {
                  setState(() {
                    _selectedProduct = value!;
                  });
                },
                listItem: widget.products
                    .map<DropdownMenuItem<Product>>((Product value) {
                  return DropdownMenuItem<Product>(
                    value: value,
                    child: Text(value.productName),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              CustomTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Quantity";
                  }
                  return null;
                },
                controller: productQuantityController,
                hintText: "Quantity",
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomElevatedButton(
                  text: "Order",
                  fontColor: Colors.white,
                  backgroundColor: Colors.black,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Order order = Order(
                          dateReceived: Timestamp.now().toDate(),
                          product: _selectedProduct,
                          orderedDate: Timestamp.now().toDate(),
                          quantity: int.parse(productQuantityController.text),
                          status: OrderStatus.pending.name);
                      BlocProvider.of<OrderBloc>(context).add(AddOrder(order));

                      success();
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
