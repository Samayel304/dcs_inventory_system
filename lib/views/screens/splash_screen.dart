import 'dart:async';

import 'package:dcs_inventory_system/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Timer(Duration(seconds: 1), () => {});
        } else if (state.status == AuthStatus.authenticated) {
          Timer(Duration(seconds: 1), () => {});
        }
      },
      child:
          Scaffold(body: Center(child: Image.asset("assets/images/logo.png"))),
    );
  }
}
