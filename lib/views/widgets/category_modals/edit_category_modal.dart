import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCategoryModel extends StatefulWidget {
  const EditCategoryModel({super.key, required this.selectedCategory});
  final Category selectedCategory;

  @override
  State<EditCategoryModel> createState() => _EditCategoryModelState();
}

class _EditCategoryModelState extends State<EditCategoryModel> {
  final TextEditingController categoryNameController = TextEditingController();

  //final _formKey = GlobalKey<FormState>();
  bool _canSave = false;

  @override
  void initState() {
    categoryNameController.text = widget.selectedCategory.categoryName;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    categoryNameController.dispose();
  }

  void editCategory(BuildContext context) {
    Category category = widget.selectedCategory
        .copyWith(categoryName: categoryNameController.text.toLowerCase());
    BlocProvider.of<CategoryBloc>(context).add(
        EditCategory(category, context, widget.selectedCategory.categoryName));
  }

  void setCanSave() {
    if (categoryNameController.text.isNotEmpty &&
        categoryNameController.text.toLowerCase() !=
            widget.selectedCategory.categoryName.toLowerCase()) {
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
                    Text("Edit Category",
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
                            editCategory(context);
                            //}
                          }),
                    )
                  ],
                ),
              ))),
    );
  }
}
