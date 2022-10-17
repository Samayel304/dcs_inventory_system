import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/views/screens/screens.dart';
import 'package:dcs_inventory_system/config/theme.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(create: (context) => ProductRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProductBloc(
                productRepository: context.read<ProductRepository>())
              ..add(LoadProducts()),
          ),
          BlocProvider(
              create: (context) => ProductCategoryBloc(
                  productBloc: BlocProvider.of<ProductBloc>(context))
                ..add(const UpdateProductCategory())),
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
        ],
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
      ),
    );
  }
}
