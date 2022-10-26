import 'package:dcs_inventory_system/views/widgets/widgets.dart';

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
      drawer: const SafeArea(child: CustomNavigationDrawer()),
      bottomNavigationBar: const BottomNavBar(index: 0),
    );
  }
}
