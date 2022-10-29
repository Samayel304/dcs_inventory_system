import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        // Important: Remove any padding from the ListView.
        //padding: EdgeInsets.zero,
        children: [
          SizedBox(
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
                      const CircleAvatar(),
                      Text("Samayel Ponce",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white)),
                      Text("admin@gmail.com",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomListTile(
            title: "Account Management",
            icon: Icons.manage_accounts_outlined,
            onTap: () {
              GoRouter.of(context).push('/manage_account');
            },
          ),
          const CustomListTile(title: "Logs", icon: Icons.note_alt_outlined),
          const Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child:
                  CustomListTile(title: "Logout", icon: Icons.logout_outlined),
            ),
          ),
        ],
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
