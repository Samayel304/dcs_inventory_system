import 'package:flutter/material.dart';

Future<dynamic> showBottomModal(BuildContext context, Widget child) {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return child;
      });
}

void showErrorSnackBar(BuildContext context, String errorMessage) {
  final snackBar = SnackBar(
    content: Text(errorMessage, textAlign: TextAlign.center),
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showSuccessSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message, textAlign: TextAlign.center),
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.green,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
