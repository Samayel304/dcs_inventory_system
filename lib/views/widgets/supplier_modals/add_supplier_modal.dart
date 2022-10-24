import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AddSupplierModal extends StatefulWidget {
  const AddSupplierModal({super.key});

  @override
  State<AddSupplierModal> createState() => _AddSupplierModalState();
}

class _AddSupplierModalState extends State<AddSupplierModal> {
  final _formKey = GlobalKey<FormState>();
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
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Add Order",
                        style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: "Supplier Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Supplier Name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hintText: "Contact Person",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Contact Person";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hintText: "Contact Number",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Contact Number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hintText: "Address",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomElevatedButton(
                          fontColor: Colors.white,
                          text: "Save",
                          backgroundColor: Colors.black,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
                          }),
                    )
                  ],
                ),
              ))),
    );
  }
}
