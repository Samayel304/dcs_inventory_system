import 'dart:async';

import 'package:dcs_inventory_system/repositories/category/category_repository.dart';
import 'package:dcs_inventory_system/views/screens/category_Screen.dart';
import 'package:dcs_inventory_system/views/screens/profile/edit_password_screen.dart';

import 'package:dcs_inventory_system/views/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import '../bloc/bloc.dart';

class AppRouter {
  final AuthBloc authBloc;

  final CategoryRepository categoryRepository;
  AppRouter(this.authBloc, this.categoryRepository);

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
          return const SplashScreen();
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
          path: '/out_of_stock',
          builder: (BuildContext context, GoRouterState state) {
            return const OutOfStockScreen();
          }),
      GoRoute(
          path: '/category',
          builder: (BuildContext context, GoRouterState state) {
            return const CategoryScreen();
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
        path: '/notification',
        builder: (context, state) {
          return const NotificationScreen();
        },
      ),
      GoRoute(
          path: '/profile',
          builder: (context, state) {
            return const ProfileScreen();
          }),
      GoRoute(
          path: '/edit_password',
          builder: (context, state) {
            return const EditPasswordScreen();
          }),
      GoRoute(
          path: '/edit_fullName',
          builder: (context, state) {
            print('refresh edit fullName');
            var currentUser =
                context.select((ProfileBloc bloc) => bloc.state.user);
            return EditFullNameScreen(currentUser: currentUser!);
          })
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool initialized = authBloc.state.isInitialized;
      final bool initializing = state.subloc == '/splash';
      final bool loggedIn = authBloc.state.status == AuthStatus.authenticated;
      final bool loggingIn = state.subloc == '/login';

      if (!initialized && !initializing) {
        return '/splash';
      } else if (initialized && !loggedIn && !loggingIn) {
        return '/login';
      } else if ((loggedIn && loggingIn) || (initialized && initializing)) {
        return '/';
      } else {
        return null;
      }

      /*   if (!loggedIn) {
        return loggingIn ? null : '/login';
      }
      if (loggingIn) {
        return '/';
      }
      */
    },
    initialLocation: '/splash',
    refreshListenable: authBloc,
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) {
      notifyListeners();

      print('go router refresh');
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
