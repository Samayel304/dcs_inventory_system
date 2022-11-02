import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AddAccountModal extends StatefulWidget {
  const AddAccountModal({super.key});

  @override
  State<AddAccountModal> createState() => _AddAccountModalState();
}

class _AddAccountModalState extends State<AddAccountModal> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Add Order", style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "FirstName",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter FirstName";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "MiddleName",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter MiddleName";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "LastName",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter LastName";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                PasswordField(
                  passwordController: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                PasswordField(
                  passwordController: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter ConfirmPassword";
                    }
                    if (value != passwordController.text) {
                      return "Password do not match.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: CustomElevatedButton(
                      text: "Save",
                      fontColor: Colors.white,
                      backgroundColor: Colors.black,
                      onPressed: () {}),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
