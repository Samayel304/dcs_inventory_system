import 'package:dcs_inventory_system/views/widgets/bottom_navbar.dart';
import 'package:dcs_inventory_system/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});
  static const routeName = "/order";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: Container(),
        bottomNavigationBar: const BottomNavBar(index: 2));
  }
}
