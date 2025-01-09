import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:livilon/features/home/presentation/screen/dimension_screen.dart';


class ChatBubble extends StatelessWidget {
  final String message;
  final Timestamp timestamp;
  final bool isSentByMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.timestamp,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    DateTime time = timestamp.toDate();
    String formattedTime = "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
    return Container(
      margin: isSentByMe
          ? const EdgeInsets.only(left: 50, top: 10, bottom: 10, right: 10)
          : const EdgeInsets.only(right: 50, top: 10, bottom: 10, left: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: isSentByMe
            ? LinearGradient(
                colors: [getButtonColor(), Colors.teal.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  const Color.fromARGB(255, 114, 165, 159),
                  getButtonColor()
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: isSentByMe
            ? const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: isSentByMe ? Colors.white : Colors.white,
            ),
          ),
           Padding(
          padding: const EdgeInsets.only(left: 10.0,),
          child: Text(
            formattedTime,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
          const SizedBox(height: 5),
         
        ],
      ),
    );
  }
}