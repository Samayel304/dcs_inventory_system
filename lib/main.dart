import 'package:dcs_inventory_system/config/theme.dart';
import 'package:dcs_inventory_system/view_models/inventory_view_model.dart';
import 'package:dcs_inventory_system/views/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => InventoryViewModel())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: theme(),
        initialRoute: "/inventory",
        routes: {
          DashboardScreen.routeName: (context) => const DashboardScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          InventoryScreen.routeName: (context) => const InventoryScreen()
        },
      ),
    );
  }
}
