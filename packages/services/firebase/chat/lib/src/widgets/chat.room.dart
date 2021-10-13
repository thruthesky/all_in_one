import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({required this.roomId, Key? key}) : super(key: key);

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (c, i) {
                return Text('Message No. $i, ...');
              },
            ),
          ),
          SafeArea(
              child: TextField(
            decoration: InputDecoration(hintText: 'Input message'),
          )),
        ],
      ),
    );
  }
}
