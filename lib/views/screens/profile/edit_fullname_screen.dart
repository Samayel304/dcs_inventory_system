import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditFullNameScreen extends StatefulWidget {
  const EditFullNameScreen({super.key, required this.currentUser});
  final UserModel currentUser;
  @override
  State<EditFullNameScreen> createState() => _EditFullNameScreenState();
}

class _EditFullNameScreenState extends State<EditFullNameScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode middleNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  UserModel? user;
  bool _canSave = false;

  @override
  void initState() {
    user = widget.currentUser;
    firstNameController.text = user!.firstName;
    middleNameController.text = user!.middleName;
    lastNameController.text = user!.lastName;

    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    firstNameFocusNode.dispose();
    middleNameFocusNode.dispose();
    lastNameFocusNode.dispose();

    super.dispose();
  }

  void editUser(BuildContext context) {
    UserModel editedUser = user!.copyWith(
        firstName: firstNameController.text,
        middleName: middleNameController.text,
        lastName: lastNameController.text);
    BlocProvider.of<UserBloc>(context).add(EditUser(editedUser, context));
    user = editedUser;
    checkChanges();
    firstNameFocusNode.unfocus();
    middleNameFocusNode.unfocus();
    lastNameFocusNode.unfocus();
  }

  void checkChanges() {
    bool isOldAndNewFirstNameNotEqual =
        firstNameController.text.toLowerCase() != user!.firstName.toLowerCase();
    bool isOldAndNewMiddleNameNotEqual =
        middleNameController.text.toLowerCase() !=
            user!.middleName.toLowerCase();
    bool isOldAndNewLastNameNotEqual =
        lastNameController.text.toLowerCase() != user!.lastName.toLowerCase();

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
                    focusNode: firstNameFocusNode,
                    onChange: (_) {
                      checkChanges();
                    },
                  ),
                  LabeledTextfield(
                    hintText: "MiddleName",
                    controller: middleNameController,
                    focusNode: middleNameFocusNode,
                    onChange: (_) {
                      checkChanges();
                    },
                  ),
                  LabeledTextfield(
                    hintText: "LastName",
                    controller: lastNameController,
                    focusNode: lastNameFocusNode,
                    onChange: (_) {
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
              )),
        ));
  }
}
