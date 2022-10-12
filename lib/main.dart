import 'package:dcs_inventory_system/config/theme.dart';
import 'package:dcs_inventory_system/view_models/inventory_view_model.dart';
import 'package:dcs_inventory_system/views/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        initialRoute: "/dashboard",
        routes: {
          DashboardScreen.routeName: (context) => const DashboardScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          InventoryScreen.routeName: (context) => const InventoryScreen(),
          OrderScreen.routeName: (context) => const OrderScreen()
        },
      ),
    );
  }
}
