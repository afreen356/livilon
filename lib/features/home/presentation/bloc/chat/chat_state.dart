import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatState {}
class ChatInitial extends ChatState{}
class ChatLoading extends ChatState{}
class ChatLoadedSuccess extends ChatState{
  final List<DocumentSnapshot> messages;

  ChatLoadedSuccess(this.messages);
}
class ChatError extends ChatState{
  final String error;

  ChatError(this.error);
}