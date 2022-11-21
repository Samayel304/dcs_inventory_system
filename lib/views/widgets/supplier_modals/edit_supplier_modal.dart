import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/supplier/supplier_bloc.dart';

class EditSupplierModal extends StatefulWidget {
  const EditSupplierModal({super.key, required this.selectedSupplier});
  final Supplier selectedSupplier;

  @override
  State<EditSupplierModal> createState() => _EditSupplierModalState();
}

class _EditSupplierModalState extends State<EditSupplierModal> {
  final TextEditingController supplierNameController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  //final _formKey = GlobalKey<FormState>();
  bool _canSave = false;

  @override
  void initState() {
    super.initState();
    supplierNameController.text = widget.selectedSupplier.supplierName;
    contactPersonController.text = widget.selectedSupplier.contactPerson;
    addressController.text = widget.selectedSupplier.address;
    contactNumberController.text = widget.selectedSupplier.contactNumber;
  }

  @override
  void dispose() {
    super.dispose();
    supplierNameController.dispose();
    contactNumberController.dispose();
    contactPersonController.dispose();
    addressController.dispose();
  }

  void editSupplier(BuildContext context) {
    Supplier supplier = widget.selectedSupplier.copyWith(
        supplierName: supplierNameController.text,
        contactPerson: contactPersonController.text,
        address: addressController.text,
        contactNumber: contactNumberController.text,
        dateCreated: Timestamp.now().toDate());
    BlocProvider.of<SupplierBloc>(context).add(EditSupplier(supplier, context));
  }

  void setCanSave() {
    bool isFieldNotEmpty = supplierNameController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        contactNumberController.text.isNotEmpty;
    bool isSupplierNameNotEqual =
        widget.selectedSupplier.supplierName.toLowerCase() !=
            supplierNameController.text.toLowerCase();

    bool isContactPersonNotEqual =
        widget.selectedSupplier.contactPerson.toLowerCase() !=
                contactPersonController.text.toLowerCase() &&
            contactPersonController.text.isNotEmpty;
    bool isAddressNotEqual = widget.selectedSupplier.address.toLowerCase() !=
        addressController.text.toLowerCase();
    bool isContactNumberNotEqual =
        widget.selectedSupplier.contactNumber != contactNumberController.text;
    if ((isSupplierNameNotEqual ||
            isContactPersonNotEqual ||
            isAddressNotEqual ||
            isContactNumberNotEqual) &&
        isFieldNotEmpty) {
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
                    Text("Edit Supplier",
                        style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: supplierNameController,
                      hintText: "Supplier Name",
                      onChange: (_) {
                        setCanSave();
                      },
                      /*   validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Supplier Name";
                        }
                        return null;
                      }, */
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: contactPersonController,
                      hintText: "Contact Person",
                      onChange: (_) {
                        setCanSave();
                      },
                      /*  validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Contact Person";
                        }
                        return null;
                      }, */
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      maxLength: 11,
                      textInputType: TextInputType.number,
                      controller: contactNumberController,
                      hintText: "Contact Number",
                      onChange: (_) {
                        setCanSave();
                      },
                      /* validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Contact Number";
                        }
                        return null;
                      }, */
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: addressController,
                      hintText: "Address",
                      onChange: (_) {
                        setCanSave();
                      },
                      /* validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Address";
                        }
                        return null;
                      }, */
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomElevatedButton(
                          fontColor: Colors.white,
                          isDisable: !_canSave,
                          text: "Save",
                          backgroundColor: Colors.black,
                          onPressed: () {
                            //if (_formKey.currentState!.validate()) {
                            editSupplier(context);
                            //}
                          }),
                    )
                  ],
                ),
              ))),
    );
  }
}
