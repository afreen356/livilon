import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/home/data/chat_service.dart';
import 'package:livilon/features/home/presentation/bloc/chat/chat_bloc.dart';
import 'package:livilon/features/home/presentation/bloc/chat/chat_event.dart';
import 'package:livilon/features/home/presentation/bloc/chat/chat_state.dart';
import 'package:livilon/features/home/presentation/screen/chat/chat_bg.dart';
import 'package:livilon/features/home/presentation/screen/dimension_screen.dart';
import 'package:livilon/features/home/presentation/widget/chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  late String adminId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(ChatService())..add(LoadMessages()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
         title:const Text('Chat With Livilon',style: TextStyle(fontWeight: FontWeight.bold),),
         ),
        
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
               return Center(
                    child: CircularProgressIndicator(color: getButtonColor(),),
               );
            }else if(state is ChatLoadedSuccess){
              return Stack(
                children:[ 
                  const ChatBackground(isDarkTheme: false),
                  Column(
                  children: [
                    Expanded(child: messageList(state.messages, context)),
                  messageinput(context)
                  ],
                ),
                ]
              );
            }else if(state is ChatError){
             return Center(child: Text('Error ${state.error}'),);
            }
            return Container();
          },
        ),
      ),
    );
  }
}

