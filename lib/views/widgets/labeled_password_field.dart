import 'package:flutter/material.dart';

import 'widgets.dart';

class LabeledPasswordField extends StatelessWidget {
  const LabeledPasswordField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.onChange,
  }) : super(key: key);
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 5, top: 10),
            child: Text(
              hintText,
              style: Theme.of(context).textTheme.headline4,
            )),
        PasswordField(
          passwordController: controller,
          onChange: onChange,
        )
      ],
    );
  }
}
