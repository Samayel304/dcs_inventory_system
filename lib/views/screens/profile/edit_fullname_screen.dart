import 'package:dcs_inventory_system/bloc/auth/auth_bloc.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EditFullNameScreen extends StatefulWidget {
  const EditFullNameScreen({super.key, required this.authUser});
  final AuthState authUser;
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

    firstNameController.text = widget.authUser.user!.firstName;
    middleNameController.text = widget.authUser.user!.middleName;
    lastNameController.text = widget.authUser.user!.lastName;
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
            widget.authUser.user!.firstName.toLowerCase();
    bool isOldAndNewMiddleNameNotEqual =
        middleNameController.text.toLowerCase() !=
            widget.authUser.user!.middleName.toLowerCase();
    bool isOldAndNewLastNameNotEqual = lastNameController.text.toLowerCase() !=
        widget.authUser.user!.lastName.toLowerCase();

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
                      onPressed: () {}),
                )
              ],
            ),
          ),
        ));
  }
}
