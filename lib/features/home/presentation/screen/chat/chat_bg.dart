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
              ? [const Color(0xFF1C1C1C), const Color(0xFF121212)] 
              : [const Color(0xFFF5F5F5), const Color(0xFFFFFFFF)], 
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}