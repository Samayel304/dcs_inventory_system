import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const _ProfilePicture(),
              Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      _UserInfo(
                        title: "FullName",
                        value: "Samayel Ponce",
                        onTap: () {
                          GoRouter.of(context).go('/profile/edit_fullname');
                        },
                      ),
                      _UserInfo(
                        title: "Email",
                        value: "samayel@gmail.com",
                        onTap: () {
                          GoRouter.of(context).go('/profile/edit_email');
                        },
                      ),
                      _UserInfo(
                        title: "Password",
                        value: "",
                        onTap: () {
                          GoRouter.of(context).go('/profile/edit_password');
                        },
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CircleAvatar(radius: 70),
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
                onPressed: () {},
              ),
            ))
      ],
    );
  }
}
