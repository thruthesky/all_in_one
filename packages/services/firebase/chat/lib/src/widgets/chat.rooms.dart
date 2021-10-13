import 'package:firebase_chat/src/chat.defines.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_chat/firebase_chat.dart';

class ChatRooms extends StatefulWidget {
  const ChatRooms({
    required this.itemBuilder,
    Key? key,
  }) : super(key: key);

  final FunctionRoomsItemBuilder itemBuilder;

  @override
  State<ChatRooms> createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  late DatabaseReference _roomsRef;

  bool _anchorToBottom = false;

  @override
  void initState() {
    super.initState();

    final FirebaseDatabase database = FirebaseDatabase();
    _roomsRef = database.reference().child('chat').child('rooms').child(chat.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('my name ${ChatService.instance.user.name}'),
        TextField(
          onSubmitted: (id) {
            print('id; $id');
            print('roomId: ${chat.getRoomId(id)}');
          },
        ),
        Expanded(
          child: FirebaseAnimatedList(
            key: ValueKey<bool>(_anchorToBottom),
            query: _roomsRef.orderByChild('samp'),
            reverse: _anchorToBottom,
            itemBuilder: (
              BuildContext context,
              DataSnapshot snapshot,
              Animation<double> animation,
              int index,
            ) {
              return SizeTransition(
                sizeFactor: animation,
                child: widget.itemBuilder(snapshot, index, () {
                  _roomsRef.child(snapshot.key!).remove();
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}
