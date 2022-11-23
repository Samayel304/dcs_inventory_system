import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAccountModal extends StatefulWidget {
  const AddAccountModal({super.key});

  @override
  State<AddAccountModal> createState() => _AddAccountModalState();
}

class _AddAccountModalState extends State<AddAccountModal> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _canSave = false;
  //final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void setCanSave() {
    bool isFieldsNotEmpty = firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
    bool isPasswordsSame =
        passwordController.text == confirmPasswordController.text;
    if (isFieldsNotEmpty && isPasswordsSame) {
      setState(() {
        _canSave = true;
      });
    } else {
      setState(() {
        _canSave = false;
      });
    }
  }

  void createUser(BuildContext context) {
    UserModel user = UserModel(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        middleName: middleNameController.text);
    BlocProvider.of<UserBloc>(context)
        .add(CreateUser(user, context, passwordController.text));
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
            //key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Add User", style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "FirstName",
                  controller: firstNameController,
                  onChange: (_) {
                    setCanSave();
                  },
                  /* validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter FirstName";
                    }
                    return null;
                  }, */
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "MiddleName",
                  controller: middleNameController,
                  onChange: (_) {
                    setCanSave();
                  },
                  /* validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter MiddleName";
                    }
                    return null;
                  }, */
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "LastName",
                  controller: lastNameController,
                  onChange: (_) {
                    setCanSave();
                  },
                  /* validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter LastName";
                    }
                    return null;
                  }, */
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "Email",
                  controller: emailController,
                  onChange: (_) {
                    setCanSave();
                  },
                  /* validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Email";
                    }
                    return null;
                  }, */
                ),
                const SizedBox(height: 10),
                PasswordField(
                  passwordController: passwordController,
                  onChange: (_) {
                    setCanSave();
                  },
                  /*  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Password";
                    }
                    return null;
                  }, */
                ),
                const SizedBox(height: 10),
                PasswordField(
                  passwordController: confirmPasswordController,
                  onChange: (_) {
                    setCanSave();
                  },
                  /*  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter ConfirmPassword";
                    }
                    if (value != passwordController.text) {
                      return "Password do not match.";
                    }
                    return null;
                  }, */
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: CustomElevatedButton(
                      isDisable: !_canSave,
                      text: "Save",
                      fontColor: Colors.white,
                      backgroundColor: Colors.black,
                      onPressed: () {
                        createUser(context);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
