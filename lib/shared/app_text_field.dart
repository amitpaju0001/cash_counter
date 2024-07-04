import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    this.fillColor,
    this.filled,
    this.borderRadius = 12,
    this.obscureText = false,
    this.controller,
    super.key,
    this.hintText,
    this.onPressed,
    this.suffixIcon,
    this.keyboardType,
  });

  final TextEditingController? controller;
  final bool obscureText;
  final String? hintText;
  final VoidCallback? onPressed;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final bool? filled;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        fillColor: fillColor ?? Colors.grey[100],
        filled: filled ?? true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter some text";
        }
        return null;
      },
    );
  }
}
