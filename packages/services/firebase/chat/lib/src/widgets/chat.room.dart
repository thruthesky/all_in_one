import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({required this.roomId, required this.onError, Key? key}) : super(key: key);

  final String roomId;
  final Function onError;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final input = TextEditingController();
  late DatabaseReference _messagesRef;

  @override
  void initState() {
    super.initState();

    final FirebaseDatabase database = FirebaseDatabase();
    _messagesRef = database.reference().child('chat').child('messages').child(widget.roomId);
  }

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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: input,
                    decoration: InputDecoration(hintText: 'Input message'),
                    onSubmitted: (x) => onSubmitText(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: onSubmitText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onSubmitText() async {
    try {
      await _messagesRef.push().set({
        'text': input.text,
        'stamp': ServerValue.timestamp,
      });
      setState(() {
        input.text = '';
      });
    } catch (e) {
      widget.onError(e);
    }
  }
}
