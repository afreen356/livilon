import 'package:flutter/material.dart';

void showCustomSnackbar(BuildContext context, String message,Color color,{Color textColor = Colors.white}) {
  
  if (message.isEmpty) {
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
       
      ),
      backgroundColor:color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      duration: const Duration(seconds: 3),
      // margin: const EdgeInsets.all(16),
    ),
  );
}

