import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/auth/presentation/widgets/text.dart';
import 'package:livilon/features/home/presentation/bloc/chat/chat_bloc.dart';
import 'package:livilon/features/home/presentation/bloc/chat/chat_event.dart';
import 'package:livilon/features/home/presentation/screen/chat/chat_bubble.dart';
import 'package:livilon/features/home/presentation/screen/dimension_screen.dart';

Widget messageList(List<DocumentSnapshot> docs, BuildContext ctx) {
  if (docs.isEmpty) {
    return Center(child: customText('No messages yet'));
  } 
  Map<String, List<DocumentSnapshot>> groupedMessages = {};
  for (var doc in docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    DateTime timestamp = (data['timestamp'] as Timestamp).toDate();
    String formattedDate = "${timestamp.day}-${timestamp.month}-${timestamp.year}";

    groupedMessages[formattedDate] = groupedMessages[formattedDate] ?? [];
    groupedMessages[formattedDate]!.add(doc);
  }
  
  
    return ListView(
    children: groupedMessages.entries.map((entry) {
      String date = entry.key;
      List<DocumentSnapshot> messages = entry.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(153, 216, 212, 212),
                
                borderRadius: BorderRadius.circular(3)
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          // Messages for this date
          ...messages.map((doc) => messageItem(doc, ctx))
        ],
      );
    }).toList(),
  );
}

Widget messageItem(DocumentSnapshot doc, BuildContext ctx) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  bool isSentByMe = data['senderId'] == currentUserId;

  bool isDeleted = data['isDeleted'] ?? false;
  if (isDeleted) {
    return Container(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(
        'This message was deleted',
        style: TextStyle(color: Colors.grey[40]),
      ),
    );
  }
  return Dismissible(
    key: Key(doc.id),
    direction: isSentByMe ? DismissDirection.endToStart : DismissDirection.none,
    confirmDismiss: (direction) async {
      return await showDialog(
          context: ctx,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Delete Message',
                style: TextStyle(color: getButtonColor()),
              ),
              content: Text(
                'Are you sure you want to delete this message?',
                style: TextStyle(color: getButtonColor()),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: getButtonColor()),
                    )),
                TextButton(
                    onPressed: () {
                      context.read<ChatBloc>().add(DeleteMessage(doc));
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Delete',
                        style: TextStyle(
                          color: Colors.red,
                        ))),
              ],
            );
          }).then((value){
           if (value) {
            ScaffoldMessenger.of(ctx).showSnackBar(
               const SnackBar(
                  backgroundColor: Colors.orange,
                  content:  Center(
                      child: Text(
                    'Message deleted',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ))),
            );
          }
          return value;
        });
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: GestureDetector(
        onTap: () async {

        },
        child: Align(
          alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: ChatBubble(
            message: data['message'],
            timestamp: data['timestamp'],
            isSentByMe: isSentByMe,
          ),
        ),
      ),
    );
  }
  Widget messageinput(BuildContext context) {
    final TextEditingController messagecontroller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messagecontroller,
              decoration: InputDecoration(
                  prefixIcon:  Icon(
                    Icons.message,
                    color: getButtonColor(),
                    size: 30,
                  ),
                  hintText: 'Type a message.....',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:  BorderSide(
                      color: getButtonColor(),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:  BorderSide(
                      color: getButtonColor(),
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    color: getButtonColor(),
                    iconSize: 35,
                    icon: const Icon(Icons.send),
                    onPressed: () {
                     context.read<ChatBloc>().add(SendMessag(messagecontroller.text));
                     messagecontroller.clear();
                     
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }