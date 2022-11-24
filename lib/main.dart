import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';
import 'package:dcs_inventory_system/cubits/login/login_cubit.dart';

import 'package:dcs_inventory_system/config/theme.dart';
import 'package:dcs_inventory_system/repositories/order/order_repository.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/app_router.dart';
import 'firebase_options.dart';

void main() async {
  //debugRepaintRainbowEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(create: (context) => ProductRepository()),
        RepositoryProvider(create: (context) => OrderRepository()),
        RepositoryProvider(create: (context) => SupplierRepository()),
        RepositoryProvider(create: (context) => ActivityLogRepository()),
        RepositoryProvider(create: (context) => CategoryRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(
                categoryRepository: context.read<CategoryRepository>(),
                productRepository: context.read<ProductRepository>())
              ..add(LoadCategory()),
          ),
          BlocProvider(
              create: (context) => ProfileBloc(
                  authRepository: context.read<AuthRepository>(),
                  userRepository: context.read<UserRepository>())
                ..add(
                  LoadProfile(),
                )),
          BlocProvider(
              create: (context) => LoginCubit(context.read<AuthRepository>())),
          BlocProvider(
              create: (context) => UserBloc(
                    userRepository: context.read<UserRepository>(),
                  )..add(LoadUsers())),
          BlocProvider(
              create: (context) => ActivityLogBloc(
                  activityLogRepository: context.read<ActivityLogRepository>())
                ..add(LoadActivityLogs())),
          BlocProvider(
            create: (context) => ProductBloc(
                productRepository: context.read<ProductRepository>(),
                activityLogBloc: context.read<ActivityLogBloc>(),
                authBloc: context.read<AuthBloc>())
              ..add(LoadProducts()),
          ),
          BlocProvider(
              create: (context) => OrderBloc(
                  orderRepository: context.read<OrderRepository>(),
                  productRepository: context.read<ProductRepository>())
                ..add(LoadOrders())),
          BlocProvider(
              create: (context) => SupplierBloc(
                  supplierRepository: context.read<SupplierRepository>())
                ..add(LoadSuppliers())),
        ],
        child: Builder(builder: (context) {
          return MaterialApp.router(
            title: 'DCS Inventory System',
            theme: theme(),
            routerConfig: AppRouter(context.read<AuthBloc>(),
                    context.read<CategoryRepository>())
                .router,
          );
        }),
      ),
    );
  }
}
