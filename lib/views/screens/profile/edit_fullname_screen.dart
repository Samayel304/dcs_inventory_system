import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditFullNameScreen extends StatefulWidget {
  const EditFullNameScreen({super.key});

  @override
  State<EditFullNameScreen> createState() => _EditFullNameScreenState();
}

class _EditFullNameScreenState extends State<EditFullNameScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool _canSave = false;

  @override
  void initState() {
    super.initState();

    /* firstNameController.text = widget.selectedUser.firstName;
    middleNameController.text = widget.selectedUser.middleName;
    lastNameController.text = widget.selectedUser.lastName; */
    /*  init(context); */
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
/* 
  void init(BuildContext context) {
    final user = context.select((AuthBloc authBloc) => authBloc.state.user!);
    firstNameController.text = user.firstName;
    middleNameController.text = user.middleName;
    lastNameController.text = user.lastName;
  } */

  void editUser(BuildContext context, UserModel user) {
    UserModel editedUser = user.copyWith(
        firstName: firstNameController.text,
        middleName: middleNameController.text,
        lastName: lastNameController.text);
    BlocProvider.of<UserBloc>(context).add(EditUser(editedUser, context));
  }

  void checkChanges(UserModel user) {
    bool isOldAndNewFirstNameNotEqual =
        firstNameController.text.toLowerCase() != user.firstName.toLowerCase();
    bool isOldAndNewMiddleNameNotEqual =
        middleNameController.text.toLowerCase() !=
            user.middleName.toLowerCase();
    bool isOldAndNewLastNameNotEqual =
        lastNameController.text.toLowerCase() != user.lastName.toLowerCase();

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
    final user = context.select((AuthBloc authBloc) => authBloc.state.user!);
    firstNameController.text = user.firstName;
    middleNameController.text = user.middleName;
    lastNameController.text = user.lastName;
    return Scaffold(
        appBar: const BackAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Loader();
                } else if (state is ProfileLoaded) {
                  UserModel user = state.user;
                  return Column(
                    children: [
                      LabeledTextfield(
                        hintText: "FirstName",
                        controller: firstNameController,
                        onChange: (value) {
                          checkChanges(user);
                        },
                      ),
                      LabeledTextfield(
                        hintText: "MiddleName",
                        controller: middleNameController,
                        onChange: (value) {
                          checkChanges(user);
                        },
                      ),
                      LabeledTextfield(
                        hintText: "LastName",
                        controller: lastNameController,
                        onChange: (value) {
                          checkChanges(user);
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
                              editUser(context, user);
                            }),
                      )
                    ],
                  );
                } else {
                  return const ErrorScreen();
                }
              },
            ),
          ),
        ));
  }
}
