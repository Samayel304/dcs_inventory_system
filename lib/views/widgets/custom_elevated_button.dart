import 'package:dcs_inventory_system/views/widgets/loader.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.backgroundColor,
    this.onPressed,
    this.fontColor = Colors.black,
    this.borderColor = Colors.black,
    this.isLoading = false,
  }) : super(key: key);
  final String text;
  final Color backgroundColor;
  final void Function()? onPressed;
  final Color? fontColor;
  final Color? borderColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: borderColor!, width: 2.0))),
      onPressed: onPressed,
      child: isLoading
          ? const Loader()
          : Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: fontColor),
            ),
    );
  }
}
