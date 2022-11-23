import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField(
      {Key? key,
      required this.passwordController,
      this.validator,
      this.onChange})
      : super(key: key);
  final TextEditingController passwordController;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true;
  void _togglePasswordView() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      onChange: widget.onChange,
      controller: widget.passwordController,
      validator: widget.validator,
      hintText: "Password",
      suffixIcon: IconButton(
          onPressed: _togglePasswordView,
          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey.shade400)),
      isObscureText: _isObscure,
    );
  }
}
