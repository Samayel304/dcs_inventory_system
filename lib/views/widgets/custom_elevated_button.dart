import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.backgroundColor,
    this.onPressed,
    this.fontColor = Colors.black,
    this.borderColor = Colors.black,
  }) : super(key: key);
  final String text;
  final Color backgroundColor;
  final void Function()? onPressed;
  final Color? fontColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: borderColor!, width: 2.0))),
      onPressed: onPressed,
      child: Text(
        text,
        style:
            Theme.of(context).textTheme.headline3!.copyWith(color: fontColor),
      ),
    );
  }
}
