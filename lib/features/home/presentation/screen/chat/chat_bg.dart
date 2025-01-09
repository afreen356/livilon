import 'package:flutter/material.dart';

class ChatBackground extends StatelessWidget {
  final bool isDarkTheme;

  const ChatBackground({required this.isDarkTheme, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkTheme
              ? [Color(0xFF1C1C1C), Color(0xFF121212)] 
              : [Color(0xFFF5F5F5), Color(0xFFFFFFFF)], 
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}