import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hintText,
      this.textInputType,
      this.isObscureText = false,
      this.isAutoCorrect = false,
      this.isEnableSuggestion = false,
      this.fillColor = Colors.white,
      this.style,
      this.borderColor = const Color(0xFFD9D9D9),
      this.suffixIcon,
      this.controller,
      this.prefixIcon,
      this.validator,
      this.onChange,
      this.maxLength,
      this.initialValue,
      this.focusNode,
      this.errorText,
      this.readOnly = false,
      this.onTap,
      this.enabled = true});

  final String hintText;
  final TextInputType? textInputType;
  final bool isObscureText;
  final bool isAutoCorrect;
  final bool isEnableSuggestion;
  final Color fillColor;
  final TextStyle? style;
  final Color borderColor;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;
  final int? maxLength;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? errorText;
  final bool readOnly;
  final void Function()? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLength: maxLength,
      onChanged: onChange,
      validator: validator,
      controller: controller,
      style: style,
      obscureText: isObscureText,
      enableSuggestions: isEnableSuggestion,
      autocorrect: isAutoCorrect,
      keyboardType: textInputType,
      focusNode: focusNode,
      readOnly: readOnly,
      onTap: onTap,
      enabled: enabled,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: style,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          fillColor: fillColor,
          errorText: errorText,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: borderColor, width: 2.0))),
    );
  }
}
