import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderEmail;
  final String recieverID;
  final String message;
  final Timestamp timestamp;
  final bool isDeleted;

  MessageModel(
      {required this.senderId,
      required this.senderEmail,
      required this.recieverID,
      required this.message,
      required this.timestamp,
      required this.isDeleted});

      Map<String,dynamic> toMap(){
        return {
          'senderId':senderId,
          'senderEmail':senderEmail,
          'recieverId':recieverID,
           'message': message,
           'timestamp':timestamp,
           'isDeleted':isDeleted
        };
      }
}
