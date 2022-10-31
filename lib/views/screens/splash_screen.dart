import 'dart:async';

import 'package:dcs_inventory_system/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.authBloc});
  final AuthBloc authBloc;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _dispatchEvent(widget.authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Image.asset("assets/images/logo_black.png")));
  }

  void _dispatchEvent(AuthBloc authBloc) {
    if (authBloc.state.status == AuthStatus.authenticated) {
      Timer(const Duration(seconds: 4), () => {GoRouter.of(context).go('/')});
    } else if (authBloc.state.status == AuthStatus.unauthenticated ||
        authBloc.state.status == AuthStatus.unknown) {
      Timer(const Duration(seconds: 4),
          () => {GoRouter.of(context).go('/login')});
    }
  }
}
