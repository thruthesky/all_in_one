import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (c, i) {
                return Text('$i');
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
