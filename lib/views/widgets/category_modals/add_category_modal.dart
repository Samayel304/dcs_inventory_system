import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/supplier/supplier_bloc.dart';

class AddCategoryModal extends StatefulWidget {
  const AddCategoryModal({super.key});

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final TextEditingController categoryNameController = TextEditingController();

  //final _formKey = GlobalKey<FormState>();
  bool _canSave = false;

  @override
  void dispose() {
    super.dispose();

    categoryNameController.dispose();
  }

  void addCategory(BuildContext context) {
    Category category = Category(
        categoryName: categoryNameController.text.toLowerCase(),
        dateCreated: Timestamp.now().toDate());
    BlocProvider.of<CategoryBloc>(context).add(AddCategory(category, context));
  }

  void setCanSave() {
    if (categoryNameController.text.isNotEmpty) {
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
                    Text("Add Category",
                        style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: categoryNameController,
                      hintText: "Category Name",
                      onChange: (_) {
                        setCanSave();
                      },
                      /* validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Supplier Name";
                        }
                        return null;
                      }, */
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomElevatedButton(
                          isDisable: !_canSave,
                          fontColor: Colors.white,
                          text: "Save",
                          backgroundColor: Colors.black,
                          onPressed: () {
                            //if (_formKey.currentState!.validate()) {
                            addCategory(context);
                            //}
                          }),
                    )
                  ],
                ),
              ))),
    );
  }
}
