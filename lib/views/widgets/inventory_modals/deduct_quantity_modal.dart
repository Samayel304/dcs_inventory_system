import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:dcs_inventory_system/views/widgets/custom_elevated_button.dart';
import 'package:dcs_inventory_system/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  // final _formKey = GlobalKey<FormState>();
  bool _canSave = false;

  @override
  void dispose() {
    super.dispose();
    productQuantityController.dispose();
  }

  void setCanSave() {
    if (productQuantityController.text.isNotEmpty &&
        int.parse(productQuantityController.text) <=
            widget.selectedProduct.quantity) {
      setState(() {
        _canSave = true;
      });
    } else {
      setState(() {
        _canSave = false;
      });
    }
  }

  void deductProductQuantity(BuildContext context) {
    int deductedQuantity = int.parse(productQuantityController.text);
    int newQuantity = widget.selectedProduct.quantity - deductedQuantity;

    BlocProvider.of<ProductBloc>(context).add(DeductProductQuantity(
        widget.selectedProduct.copyWith(quantity: newQuantity),
        deductedQuantity,
        context));
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
              Text("Deduct Quantity",
                  style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                      '${widget.selectedProduct.productName.toTitleCase()} quantity: '),
                  Text('${widget.selectedProduct.quantity}')
                ],
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: productQuantityController,
                onChange: (_) {
                  setCanSave();
                },
                /*  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter quantity";
                    } else if (int.parse(value) >
                        widget.selectedProduct.quantity) {
                      return "Quantity exceeded";
                    }
                    return null;
                  }, */
                hintText: "Quantity",
                textInputType: TextInputType.number,
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
                    deductProductQuantity(context);
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
