import 'package:dcs_inventory_system/cubits/login/login_cubit.dart';

import 'package:dcs_inventory_system/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/constants.dart';
import '../widgets/custom_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(Constant.whiteLogoPath),
                  const SizedBox(height: 15),
                  _EmailInput(),
                  const SizedBox(height: 15),
                  _PasswordInput(),
                  const SizedBox(height: 15),
                  _LoginButton(formKey: _formKey)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return CustomTextField(
          onChange: (email) {
            context.read<LoginCubit>().emailChanged(email);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter Email";
            }
            return null;
          },
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.grey.shade400),
          hintText: "Email",
          borderColor: Colors.grey.shade400,
          fillColor: const Color(0xFF171515),
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _isObscure = true;
  void _togglePasswordView() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return CustomTextField(
          onChange: (password) {
            context.read<LoginCubit>().passwordChanged(password);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter Password";
            }
            return null;
          },
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.grey.shade400),
          hintText: "Password",
          suffixIcon: IconButton(
              onPressed: _togglePasswordView,
              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade400)),
          borderColor: Colors.grey.shade400,
          fillColor: const Color(0xFF171515),
          isObscureText: _isObscure,
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const _LoginButton({Key? key, required this.formKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return SizedBox(
            width: double.infinity,
            height: 50,
            child: CustomElevatedButton(
              isLoading: state.status == LoginStatus.submitting,
              text: "Login",
              backgroundColor: Colors.white,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<LoginCubit>().logInWithCredentials(context);
                }
              },
            ));
      },
    );
  }
}
