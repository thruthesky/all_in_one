import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatMessageButtomActionsWidget extends StatefulWidget {
  ChatMessageButtomActionsWidget({
    this.onError,
    this.onPressUploadIcon,
  });

  final Function? onError;

  final Function? onPressUploadIcon;

  @override
  _ChatMessageButtomActionsWidgetState createState() => _ChatMessageButtomActionsWidgetState();
}

class _ChatMessageButtomActionsWidgetState extends State<ChatMessageButtomActionsWidget> {
  /// show loader if sending is true
  bool sending = false;

  dynamic isMessageEdit;

  // send a message to the room users
  sendMessage() async {
    String text = ChatRoom.instance.textController.text;
    if (text.isEmpty || sending) return;
    sending = true;

    ChatRoom.instance.textController.text = '';

    try {
      if (isMessageEdit == null) {
        await ChatRoom.instance
            .sendMessage(text: text, displayName: ChatRoom.instance.displayName!);
      } else {
        await ChatRoom.instance
            .sendMessage(text: text, displayName: ChatRoom.instance.displayName!);
      }
      sending = false;
    } catch (e) {
      sending = false;
      onError(e);
    }
    setState(() {});
    // Api.instance.chat.notify();  // Notify changes
  }

  onError(dynamic e) {
    if (widget.onError != null) widget.onError!(e);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (ChatRoom.instance.progress > 0)
          LinearProgressIndicator(
            value: ChatRoom.instance.progress,
          ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              /// Upload Icon Button
              IconButton(

                  /// if progress is not 0, show loader.
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    // emit press instead of callback
                    if (widget.onPressUploadIcon != null) widget.onPressUploadIcon!();
                  }),
              Expanded(
                child: TextFormField(
                  controller: ChatRoom.instance.textController,
                  onEditingComplete: sendMessage,
                  decoration: InputDecoration(
                    hintText: "Please enter your message.",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        color: Colors.amber[600]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        color: Colors.blueGrey[300]!,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              sending
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('...'),
                    )
                  : IconButton(
                      onPressed: sendMessage,
                      icon: Icon(Icons.send),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
