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

void showErrorSnackBar(BuildContext context) {
  const snackBar = SnackBar(
    content: Text("Error", textAlign: TextAlign.center),
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 3),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showSuccessSnackBar(BuildContext context) {
  const snackBar = SnackBar(
    content: Text("Success", textAlign: TextAlign.center),
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 3),
    backgroundColor: Colors.green,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
