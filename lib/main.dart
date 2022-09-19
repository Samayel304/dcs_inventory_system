import 'package:dcs_inventory_system/views/screens/screens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/dashboard",
      routes: {
        DashboardScreen.routeName: (context) => const DashboardScreen(),
        LoginScreen.routeName: (context) => const LoginScreen()
      },
    );
  }
}
