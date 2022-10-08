import 'package:dcs_inventory_system/views/widgets/bottom_navbar.dart';
import 'package:dcs_inventory_system/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static const routeName = '/dashboard';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(), bottomNavigationBar: BottomNavBar(index: 0));
  }
}
