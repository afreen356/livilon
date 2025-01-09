import 'package:flutter/material.dart';

class CustomAddressForm extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController controller;

  final String hintText;
  final TextInputType keyboardType;

  // ignore: use_super_parameters
  const CustomAddressForm({
    key,
    required this.controller,
    required this.validator,
    required this.hintText,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black26),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(135, 220, 211, 211)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(135, 220, 211, 211)),
        ),
      ),
    );
  }
}
String? validateFullName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your full name';
  }
  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
    return 'Name must only contain letters and spaces';
  }
  if (value.split(' ').length < 2) {
    return 'Please enter your full name (e.g., John Doe)';
  }
  return null;
}
String? validatePhoneNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your phone number';
  }
  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
    return 'Phone number must be 10 digits long';
  }
  return null;
}
String? validatePincode(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your pincode';
  }
  if (!RegExp(r'^\d{6}$').hasMatch(value)) {
    return 'Pincode must be 6 digits long';
  }
  return null;
}
String? validateLocation(String? value,String fieldname) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your $fieldname';
  }
  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
    return '$fieldname name must only contain letters and spaces';
  }
  return null;
}

Widget customAppbar(String text) {
  return AppBar(
    backgroundColor: Colors.transparent,
    title: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
