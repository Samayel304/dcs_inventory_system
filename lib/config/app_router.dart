import 'dart:async';

import 'package:dcs_inventory_system/views/screens/profile/edit_password_screen.dart';
import 'package:dcs_inventory_system/views/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/bloc.dart';

class AppRouter {
  final AuthBloc authBloc;
  AppRouter(this.authBloc);

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const DashboardScreen();
        },
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) {
          return SplashScreen(
            authBloc: authBloc,
          );
        },
      ),
      GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          }),
      GoRoute(
          path: '/inventory',
          builder: (BuildContext context, GoRouterState state) {
            return const InventoryScreen();
          }),
      GoRoute(
          path: '/order',
          builder: (BuildContext context, GoRouterState state) {
            return const OrderScreen();
          }),
      GoRoute(
          path: '/supplier',
          builder: (BuildContext context, GoRouterState state) {
            return const SupplierScreen();
          }),
      GoRoute(
        path: '/manage_account',
        builder: (context, state) {
          return const ManageAccountScreen();
        },
      ),
      GoRoute(
        path: '/activity_log',
        builder: (context, state) {
          return const ActivityLogScreen();
        },
      ),
      GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileScreen();
          },
          routes: [
            GoRoute(
                path: 'edit_fullname',
                builder: (context, state) {
                  final authUser =
                      context.select((AuthBloc authBloc) => authBloc.state);
                  return EditFullNameScreen(authUser: authUser);
                }),
            GoRoute(
                path: 'edit_email',
                builder: (context, state) {
                  return const EditEmailScreen();
                }),
            GoRoute(
                path: 'edit_password',
                builder: (context, state) {
                  return const EditPasswordScreen();
                })
          ])
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authBloc.state.status == AuthStatus.authenticated;
      final bool loggingIn = state.subloc == '/login';

      if (!loggedIn) {
        return loggingIn ? null : '/login';
      }
      if (loggingIn) {
        return '/inventory';
      }
      return null;
    },
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
