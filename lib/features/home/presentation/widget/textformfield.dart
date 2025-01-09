


import 'package:flutter/material.dart';

class CustomTextformfield extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;

  const CustomTextformfield({
    super.key,
    this.validator,
    this.controller,
    this.labelText,
    this.hintText
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      keyboardType: TextInputType.number,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
       border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
       borderSide: BorderSide.none
       ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(10),
        //   borderSide: const BorderSide(color: Colors.grey, width: 1),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(10),
        //   borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        // ),
         floatingLabelBehavior: FloatingLabelBehavior.auto, 
       filled: true,
       fillColor: const Color.fromARGB(238, 237, 232, 232),
       labelText: labelText,
       hintText: hintText,
       hintStyle: const TextStyle(color: Colors.grey),

        contentPadding: const EdgeInsets.symmetric(horizontal: 10,),
      ),
    );
  }


}
  String? validateDimension(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    final numValue = double.tryParse(value);
    if (numValue == null || numValue <= 0) {
      return '$fieldName must be greater than 0';
    }
    if (numValue > 500) {
      return '$fieldName cannot exceed 500 cm';
    }
    return null;
  }
