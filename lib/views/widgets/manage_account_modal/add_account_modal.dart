import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
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

  String? get _passwordErroText {
    // at any time, we can get the text from _controller.value.text
    final text = passwordController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return null;
    }
    if (text.length < 6) {
      return 'Password should be atleast 6 characters';
    }
    // return null if the text is valid
    return null;
  }

  String? get _emailValidator {
    final value = emailController.value.text;
    if (value.isEmpty) {
      return null;
    }
    if (!EmailValidator.validate(value)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

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
    bool passwordsGreaterThanSix = passwordController.text.length >= 6;
    if (isFieldsNotEmpty &&
        isPasswordsSame &&
        passwordsGreaterThanSix &&
        EmailValidator.validate(emailController.text)) {
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
                  errorText: _emailValidator,
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
                  hintText: 'Password',
                  errorText: _passwordErroText,
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
                  hintText: 'Confirm Password',
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
