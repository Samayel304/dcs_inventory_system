import 'package:dcs_inventory_system/views/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final GoRouter router = GoRouter(debugLogDiagnostics: true, routes: <GoRoute>[
    GoRoute(
      path: "/",
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    )
  ]);
}
