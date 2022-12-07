import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';
import 'package:dcs_inventory_system/models/user_model.dart';
import 'package:dcs_inventory_system/utils/enums.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        if (state is UserLoading) {
          return const Loader();
        } else if (state is UserLoaded) {
          final currentUser = FirebaseAuth.instance.currentUser;
          UserModel authUser =
              state.users.where((user) => user.id == currentUser!.uid).first;
          bool isAdmin = authUser.role == UserRole.admin.name;
          return Column(
            children: [
              const _Header(),
              CustomListTile(
                title: "Account Management",
                icon: Icons.manage_accounts_outlined,
                onTap: () {
                  Navigator.pop(context);
                  GoRouter.of(context).push('/manage_account');
                },
                isAdmin: isAdmin,
              ),
              CustomListTile(
                title: "Supplier",
                icon: Icons.local_shipping_outlined,
                onTap: () {
                  Navigator.pop(context);
                  GoRouter.of(context).push('/supplier');
                },
                isAdmin: isAdmin,
              ),
              CustomListTile(
                title: "Logs",
                icon: Icons.note_alt_outlined,
                onTap: () {
                  Navigator.pop(context);
                  GoRouter.of(context).push('/activity_log');
                },
                isAdmin: isAdmin,
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: CustomListTile(
                    title: "Logout",
                    icon: Icons.logout_outlined,
                    onTap: () {
                      BlocProvider.of<AuthBloc>(context)
                          .add(AuthLogoutRequested());
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const ErrorScreen();
        }
      }),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Loader();
          } else if (state is UserLoaded) {
            UserModel authUser =
                state.users.where((user) => user.id == currentUser!.uid).first;
            String fullName =
                '${authUser.firstName} ${authUser.middleName} ${authUser.lastName}';
            String email = authUser.email;
            String avatarUrl = authUser.avatarUrl;
            return InkWell(
              onTap: () {
                if (authUser.role == UserRole.admin.name) {
                  Navigator.pop(context);
                  GoRouter.of(context).push('/profile');
                }
              },
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                margin: const EdgeInsets.all(0.0),
                child: Center(
                    child: Column(
                  children: [
                    CircleAvatar(
                        radius: (45),
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.network(avatarUrl))),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(fullName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white)),
                    Text(email,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white)),
                  ],
                )),
              ),
            );
          } else {
            return const ErrorScreen();
          }
        },
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
    this.isAdmin = true,
  }) : super(key: key);
  final String title;
  final IconData icon;
  final void Function()? onTap;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return isAdmin
        ? ListTile(
            leading: Icon(
              icon,
              color: Colors.black,
            ),
            title: Text(title, style: Theme.of(context).textTheme.headline5),
            onTap: onTap)
        : const SizedBox();
  }
}
