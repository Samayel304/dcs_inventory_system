import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    this.fontColor = Colors.black,
  }) : super(key: key);
  final String text;
  final Color backgroundColor;
  final Function onPressed;
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Colors.black, width: 2.0))),
      onPressed: () {
        onPressed();
      },
      child: Text(
        text,
        style:
            Theme.of(context).textTheme.headline3!.copyWith(color: fontColor),
      ),
    );
  }
}
