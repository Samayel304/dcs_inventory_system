import 'package:flutter/material.dart';
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

String formatDateTime(DateTime dateTime) {
  String formatedDateTime = DateFormat("MMM dd, yyyy").format(dateTime);
  return formatedDateTime;
}

extension StringExtension on String {
  String toTitleCase() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
