import 'package:firebase_chat/src/chat.defines.dart';
import 'package:flutter/material.dart';
import 'package:firebase_chat/firebase_chat.dart';

class ChatRooms extends StatelessWidget {
  const ChatRooms({
    required this.onEnter,
    Key? key,
  }) : super(key: key);

  final FunctionEnter onEnter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('my name ${ChatService.instance.user.name}'),
        TextField(
          onSubmitted: (id) {
            print('id; $id');
            print('roomId: ${chat.getRoomId(id)}');
            onEnter(chat.getRoomId(id));
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 100,
            itemBuilder: (c, i) {
              return Text('$i');
            },
          ),
        ),
      ],
    );
  }
}
