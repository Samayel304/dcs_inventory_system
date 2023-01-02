import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

String formatCurrency(double value) {
  var format = NumberFormat.compactCurrency(
          locale: 'en-PH', symbol: '₱', decimalDigits: 0)
      .format(value);
  return format;
}

Color statusFormatColor(String status) {
  switch (status) {
    case "pending":
      return Colors.orange.shade400;
    case "received":
      return Colors.green;
    case "cancelled":
      return Colors.red.shade600;
  }
  return Colors.black;
}

const String dateFormatter = 'MMMM dd, y';
const String greetingsDateFormatter = 'EEEE, dd MMMM';
const String dateTimeFormatter = 'MMMM dd, y kk:mm:a';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  String formatDateTime() {
    final formatter = DateFormat(dateTimeFormatter);
    return formatter.format(this);
  }

  String formatGreetingsDate() {
    final formatter = DateFormat(greetingsDateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}

extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

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
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message, textAlign: TextAlign.center),
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<dynamic> showAlertDialog(
    {required BuildContext context,
    required String title,
    required String content,
    void Function()? onPressed}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'No'),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: onPressed,
                child: const Text('Yes'),
              ),
            ],
          ));
}

Future<XFile?> getImage() async {
  ImagePicker picker = ImagePicker();

  XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image;
}
