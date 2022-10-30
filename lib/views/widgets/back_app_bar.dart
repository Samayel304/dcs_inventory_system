import 'package:flutter/material.dart';

class BackAppBar extends StatelessWidget with PreferredSizeWidget {
  const BackAppBar({
    Key? key,
    this.actions,
  }) : super(key: key);
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
