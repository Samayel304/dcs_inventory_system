import 'package:dcs_inventory_system/views/screens/screens.dart';
import 'package:dcs_inventory_system/views/widgets/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Image.asset("assets/images/logo.png"),
                const SizedBox(height: 15),
                CustomTextField(
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.grey.shade400),
                  hintText: "Email",
                  borderColor: Colors.grey.shade400,
                  fillColor: const Color(0xFF171515),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.grey.shade400),
                  hintText: "Password",
                  suffixIcon: IconButton(
                      onPressed: _togglePasswordView,
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey.shade400)),
                  borderColor: Colors.grey.shade400,
                  fillColor: const Color(0xFF171515),
                  isObscureText: _isObscure,
                ),
                const SizedBox(height: 15),
                SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () {
                        Navigator.pushNamed(context, DashboardScreen.routeName);
                      },
                      child: Text(
                        "Login",
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: Colors.black),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }
}
