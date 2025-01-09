import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatEvent {}

class LoadMessages extends ChatEvent{} 

class SendMessag extends ChatEvent{
  final String message;

  SendMessag( this.message);
}

class DeleteMessage extends ChatEvent{
  final DocumentSnapshot message;

  DeleteMessage(this.message);
  
}
