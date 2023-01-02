import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/model.dart';
import '../../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BackAppBar(),
      body: Center(
        child: ProfileDetails(),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          const Loader();
        }
        if (state is UserLoaded) {
          final currentUid = FirebaseAuth.instance.currentUser!.uid;
          UserModel authUser =
              state.users.where((user) => user.id == currentUid).first;
          String fullName =
              '${authUser.firstName} ${authUser.middleName} ${authUser.lastName}';
          String email = authUser.email;
          return Column(
            children: [
              _ProfilePicture(user: authUser),
              Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      _UserInfo(
                        title: "FullName",
                        value: fullName,
                        onTap: () {
                          GoRouter.of(context).push('/edit_fullname');
                          /* showBottomModal(
                              context, EditFullName(selectedUser: authUser)); */
                        },
                      ),
                      _UserInfo(
                        title: "Email",
                        value: email,
                      ),
                      _UserInfo(
                        title: "Password",
                        value: "",
                        onTap: () {
                          GoRouter.of(context).push('/edit_password');
                        },
                      ),
                    ],
                  ))
            ],
          );
        } else {
          return const ErrorScreen();
        }
      },
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo({
    Key? key,
    required this.title,
    required this.value,
    this.onTap,
  }) : super(key: key);
  final String title;
  final String value;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      //hoverColor: Colors.grey,
      //splashColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: const Color.fromARGB(221, 31, 30, 30))),
            Row(
              children: [
                Text(value,
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Colors.grey)),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ProfilePicture extends StatelessWidget {
  const _ProfilePicture({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
            radius: (70),
            backgroundColor: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Image.network(user.avatarUrl),
            )),
        Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 45,
              height: 45,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.withOpacity(0.6)),
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  XFile? image = await getImage();
                  if (image != null) {
                    BlocProvider.of<UserBloc>(context)
                        .add(ChangeProfilePicture(user, context, image));
                  }
                },
              ),
            ))
      ],
    );
  }
}
