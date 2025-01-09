import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/home/data/chat_service.dart';
import 'package:livilon/features/home/presentation/bloc/chat/chat_event.dart';
import 'package:livilon/features/home/presentation/bloc/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService chatService;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late String adminId;
  ChatBloc(this.chatService) : super(ChatInitial()) {
    on<LoadMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        DocumentSnapshot adminDoc = await FirebaseFirestore.instance
            .collection('admindetails')
            .doc('admin')
            .get();
        adminId = adminDoc.id;
        await emit.forEach(
          chatService.getMessages(adminId, firebaseAuth.currentUser!.uid),
          onData: (snapshot) => ChatLoadedSuccess(snapshot.docs),
          onError: (error, stackTrace) => ChatError(error.toString()),
        );
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<SendMessag>((event, emit) async {
      try {
        await chatService.sendmessage(adminId, event.message);
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
    
    on<DeleteMessage>((event, emit) async {
      try {
        String messageId = event.message.id;
        await chatService.deleteMessage(adminId, messageId);
        List<DocumentSnapshot> updatedMessage =
            List.from((state as ChatLoadedSuccess).messages)
              ..remove(event.message);
        emit(ChatLoadedSuccess(updatedMessage));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
