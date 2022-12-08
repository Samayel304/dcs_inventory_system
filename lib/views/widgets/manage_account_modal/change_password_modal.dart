import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';

import 'package:dcs_inventory_system/models/model.dart';

import 'package:dcs_inventory_system/views/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordModal extends StatefulWidget {
  const ChangePasswordModal({Key? key, required this.selectedUser})
      : super(key: key);
  final UserModel selectedUser;
  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  TextEditingController newPasswordController = TextEditingController();

  bool _canSave = false;

  @override
  void dispose() {
    newPasswordController.dispose();

    super.dispose();
  }

  String? get _passwordErrorText {
    // at any time, we can get the text from _controller.value.text
    final text = newPasswordController.value.text;
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

  void checkChanges() {
    bool passwordsGreaterThanSix = newPasswordController.text.length >= 6;
    if (newPasswordController.text.isNotEmpty && passwordsGreaterThanSix) {
      setState(() {
        _canSave = true;
      });
    } else {
      setState(() {
        _canSave = false;
      });
    }
  }

  void editPassword(BuildContext context) {
    BlocProvider.of<UserBloc>(context).add(ChangeUserPassword(
        widget.selectedUser.id!, context, newPasswordController.text));
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Change Password",
                  style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 20),
              PasswordField(
                passwordController: newPasswordController,
                errorText: _passwordErrorText,
                onChange: (value) {
                  checkChanges();
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomElevatedButton(
                    isDisable: !_canSave,
                    fontColor: Colors.white,
                    text: "Save Changes",
                    borderColor: Colors.black,
                    backgroundColor: Colors.black,
                    onPressed: () {
                      editPassword(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
