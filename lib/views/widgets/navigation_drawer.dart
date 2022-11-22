import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/user_model.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const _Header(),
          CustomListTile(
            title: "Account Management",
            icon: Icons.manage_accounts_outlined,
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).push('/manage_account');
            },
          ),
          CustomListTile(
            title: "Supplier",
            icon: Icons.local_shipping_outlined,
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).push('/supplier');
            },
          ),
          CustomListTile(
            title: "Logs",
            icon: Icons.note_alt_outlined,
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).push('/activity_log');
            },
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: CustomListTile(
                title: "Logout",
                icon: Icons.logout_outlined,
                onTap: () {
                  BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequested());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Loader();
          } else if (state is ProfileLoaded) {
            UserModel authUser = state.user;
            String fullName =
                '${authUser.firstName} ${authUser.middleName} ${authUser.lastName}';
            String email = authUser.email;
            String avatarUrl = authUser.avatarUrl;
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                GoRouter.of(context).push('/profile');
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
                        radius: (50),
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(avatarUrl))),
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
  }) : super(key: key);
  final String title;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: Text(title, style: Theme.of(context).textTheme.headline5),
        onTap: onTap);
  }
}
