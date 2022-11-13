import 'package:dcs_inventory_system/bloc/auth/auth_bloc.dart';
import 'package:dcs_inventory_system/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.select((AuthBloc auth) => auth.state);
    final fullName = auth.status == AuthStatus.authenticated
        ? '${auth.user!.firstName} ${auth.user!.middleName} ${auth.user!.lastName}'
        : '';
    return Drawer(
      child: Column(
        // Important: Remove any padding from the ListView.
        //padding: EdgeInsets.zero,
        children: [
          _Header(user: auth.user, fullName: fullName),
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
                  //GoRouter.of(context).go('/login');
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
    this.user,
    required this.fullName,
  }) : super(key: key);

  final User? user;
  final String fullName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
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
                      child: Image.network(user?.avatarUrl ??
                          'https://firebasestorage.googleapis.com/v0/b/dcsims-2772c.appspot.com/o/default_profile.png?alt=media&token=9c83c05f-2d6b-4def-8c08-cf212738605d'),
                    )),
                Text(fullName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white)),
                Text(user?.email ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white)),
              ],
            ),
          ),
        ),
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
