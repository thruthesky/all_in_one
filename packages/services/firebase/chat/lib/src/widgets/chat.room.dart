import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
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
  late DatabaseReference _myRoomsRef;
  late DatabaseReference _otherRoomsRef;
  bool _anchorToBottom = true;

  // List<ChatMessageModel> messages = [];

  /// Get my uid from roomId.
  /// If (only if) this widget is called before the user login, then `chat.user.uid` is empty.
  /// This may happens only when testing by openning the chat room screen immediately on app booting.
  late String myUid;
  late String otherUid;

  @override
  void initState() {
    super.initState();

    myUid = widget.roomId.split('_').first;
    otherUid = widget.roomId.split('_').last;

    final FirebaseDatabase database = FirebaseDatabase();

    ///
    _messagesRef = database.reference().child('chat').child('messages').child(widget.roomId);
    _myRoomsRef = database.reference().child('chat').child('rooms').child(myUid);
    _otherRoomsRef = database.reference().child('chat').child('rooms').child(otherUid);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              key: ValueKey<bool>(_anchorToBottom),
              query: _messagesRef,
              sort: sortByKey,
              reverse: _anchorToBottom,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: ListTile(
                    trailing: IconButton(
                      onPressed: () => _messagesRef.child(snapshot.key!).remove(),
                      icon: const Icon(Icons.delete),
                    ),
                    title: Text(
                      '$index: ${snapshot.value['text']}',
                    ),
                  ),
                );
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

  void onSubmitText() {
    _messagesRef.push().set({
      'text': input.text,
      'stamp': ServerValue.timestamp,
    }).then((x) {
      setState(() {
        input.text = '';
      });
    }).catchError(widget.onError);

    /// Update other user room information under my room list.
    _myRoomsRef.child(otherUid).set({
      'text': input.text, // last chat message,
      'stamp': ServerValue.timestamp, // time of last chat message,
    }).then((x) {
      setState(() {
        input.text = '';
      });
    }).catchError(widget.onError);

    /// Update my room information under the other user's room list.
    _otherRoomsRef.child(myUid).set({
      'text': input.text, // last chat message,
      'stamp': ServerValue.timestamp, // time of last chat message,
      'newMessages': ServerValue.increment(1),
    }).then((x) {
      setState(() {
        input.text = '';
      });
    }).catchError(widget.onError);
  }

  /// Sort by key desc
  int sortByKey(DataSnapshot a, DataSnapshot b) {
    int re = a.key!.compareTo(b.key!);
    if (re == 0) {
      return 0;
    } else {
      return re < 0 ? 1 : -1;
    }
  }
}
