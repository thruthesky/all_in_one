import 'package:flutter/material.dart';

class ChatRooms extends StatelessWidget {
  const ChatRooms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (c, i) {
        return Text('$i');
      },
    );
  }
}
