import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
   const AppTextField({
    this.obscureText = false,
    this.controller,
    super.key, this.hintText, this.onPressed, this.suffixIcon,this.keyboardType,});
  final TextEditingController? controller;
  final bool obscureText;
  final String? hintText;
  final VoidCallback? onPressed;
  final Widget?  suffixIcon;
   final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: controller,
      obscureText: obscureText,
        keyboardType: keyboardType, textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          suffixIcon: suffixIcon
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
