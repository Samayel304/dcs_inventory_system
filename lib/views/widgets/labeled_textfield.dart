import 'package:flutter/material.dart';

import 'widgets.dart';

class LabeledTextfield extends StatelessWidget {
  const LabeledTextfield({
    Key? key,
    required this.hintText,
  }) : super(key: key);
  final String hintText;

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
        CustomTextField(hintText: hintText)
      ],
    );
  }
}
