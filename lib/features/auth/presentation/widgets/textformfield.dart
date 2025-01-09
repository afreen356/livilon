import 'package:flutter/material.dart';

class CustomTextformfield extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? hintText;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final Widget? suffixIcon;

  const CustomTextformfield({
    super.key,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.hintText,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
         hintStyle:const TextStyle(
          color: Colors.grey, 
        ),
        prefixIcon: prefixIcon != null
            ? IconTheme(
                data: IconThemeData(color: prefixIconColor),
                child: prefixIcon!,
              )
            : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // filled: true,
        // fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}
