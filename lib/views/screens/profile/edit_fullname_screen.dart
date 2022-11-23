import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditFullNameScreen extends StatefulWidget {
  const EditFullNameScreen({super.key, required this.selectedUser});
  final UserModel selectedUser;
  @override
  State<EditFullNameScreen> createState() => _EditFullNameScreenState();
}

class _EditFullNameScreenState extends State<EditFullNameScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
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

  void editUser(BuildContext context) {
    UserModel user = widget.selectedUser.copyWith(
        firstName: firstNameController.text,
        middleName: middleNameController.text,
        lastName: lastNameController.text);
    BlocProvider.of<UserBloc>(context).add(EditUser(user, context));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                LabeledTextfield(
                  hintText: "FirstName",
                  controller: firstNameController,
                  onChange: (value) {
                    checkChanges();
                  },
                ),
                LabeledTextfield(
                  hintText: "MiddleName",
                  controller: middleNameController,
                  onChange: (value) {
                    checkChanges();
                  },
                ),
                LabeledTextfield(
                  hintText: "LastName",
                  controller: lastNameController,
                  onChange: (value) {
                    checkChanges();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
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
        ));
  }
}
