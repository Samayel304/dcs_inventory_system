import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(int value) {
  var format = NumberFormat.compactCurrency(
          locale: 'en-PH', symbol: '₱', decimalDigits: 0)
      .format(value);
  return format;
}

Color statusFormatColor(String status) {
  switch (status) {
    case "Pending":
      return Colors.orange.shade400;
    case "Received":
      return Colors.green.shade300;
    case "Cancelled":
      return Colors.red.shade600;
  }
  return Colors.black;
}
