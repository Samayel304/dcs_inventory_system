import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';

import 'package:dcs_inventory_system/models/model.dart';

import 'package:dcs_inventory_system/views/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditFullName extends StatefulWidget {
  const EditFullName({
    Key? key,
    required this.selectedUser,
  }) : super(key: key);
  final UserModel selectedUser;

  @override
  State<EditFullName> createState() => _EditFullNameState();
}

class _EditFullNameState extends State<EditFullName> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool _canSave = false;

  @override
  void initState() {
    super.initState();

    firstNameController.text = widget.selectedUser.firstName;
    middleNameController.text = widget.selectedUser.middleName;
    lastNameController.text = widget.selectedUser.lastName;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void checkChanges() {
    bool isOldAndNewFirstNameNotEqual =
        firstNameController.text.toLowerCase() !=
            widget.selectedUser.firstName.toLowerCase();
    bool isOldAndNewMiddleNameNotEqual =
        middleNameController.text.toLowerCase() !=
            widget.selectedUser.middleName.toLowerCase();
    bool isOldAndNewLastNameNotEqual = lastNameController.text.toLowerCase() !=
        widget.selectedUser.lastName.toLowerCase();

    bool isAllFieldNotEmpty = firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty;

    if ((isOldAndNewFirstNameNotEqual ||
            isOldAndNewMiddleNameNotEqual ||
            isOldAndNewLastNameNotEqual) &&
        isAllFieldNotEmpty) {
      setState(() {
        _canSave = true;
      });
    } else {
      setState(() {
        _canSave = false;
      });
    }
  }

  void editUser(BuildContext context) {
    UserModel user = widget.selectedUser.copyWith(
        firstName: firstNameController.text,
        middleName: middleNameController.text,
        lastName: lastNameController.text);
    BlocProvider.of<UserBloc>(context).add(EditUser(user, context));
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
              Text("Edit Fullname",
                  style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: "FirstName",
                controller: firstNameController,
                onChange: (value) {
                  checkChanges();
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: "MiddleName",
                controller: middleNameController,
                onChange: (value) {
                  checkChanges();
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: "LastName",
                controller: lastNameController,
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
                      editUser(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
