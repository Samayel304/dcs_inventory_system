import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/views/widgets/custom_elevated_button.dart';
import 'package:dcs_inventory_system/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/model.dart';

class DeductQuantityModal extends StatefulWidget {
  const DeductQuantityModal({
    Key? key,
    required this.selectedProduct,
  }) : super(key: key);

  final Product selectedProduct;

  @override
  State<DeductQuantityModal> createState() => _DeductQuantityModalState();
}

class _DeductQuantityModalState extends State<DeductQuantityModal> {
  TextEditingController productQuantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
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
                  Text("Deduct Quantity",
                      style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: productQuantityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter quantity";
                      } else if (int.parse(value) >
                          widget.selectedProduct.quantity) {
                        return "Quantity exceeded";
                      }
                      return null;
                    },
                    hintText: "Quantity",
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
                          int newQuantity = widget.selectedProduct.quantity -
                              int.parse(productQuantityController.text);

                          context.read<ProductBloc>().add(DeductProductQuantity(
                              widget.selectedProduct
                                  .copyWith(quantity: newQuantity)));

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
      },
    );
  }
}
