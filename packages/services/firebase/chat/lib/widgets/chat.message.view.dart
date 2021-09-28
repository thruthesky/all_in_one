import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';

class ChatMessageViewWidget extends StatefulWidget {
  ChatMessageViewWidget({
    required this.message,
    Key? key,
  }) : super(key: key);

  final ChatMessage message;

  @override
  _ChatMessageViewWidgetState createState() => _ChatMessageViewWidgetState();
}

class _ChatMessageViewWidgetState extends State<ChatMessageViewWidget> {
  bool isMessageOnEdit = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!widget.message.isMine)
          Container(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              widget.message.senderDisplayName,
              textAlign: widget.message.isMine ? TextAlign.right : TextAlign.left,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ChatBubble(
          clipper: widget.message.isMine
              ? ChatBubbleClipper4(type: BubbleType.sendBubble)
              : ChatBubbleClipper4(type: BubbleType.receiverBubble),
          alignment: widget.message.isMine ? Alignment.topRight : Alignment.topLeft,
          backGroundColor: Colors.blue,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: widget.message.isImage
                ? CachedImage(
                    widget.message.text,
                    onLoadComplete: () {
                      ChatRoom.instance.scrollToBottom();
                    },
                  )
                : Text(
                    ChatRoom.instance.text(widget.message),
                    textAlign: widget.message.isMine ? TextAlign.right : TextAlign.left,
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment:
                widget.message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              ChatRoom.instance.isMessageOnEdit(widget.message)
                  ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          'Edit Cancel',
                          style: TextStyle(fontSize: 8, color: Colors.red),
                        ),
                      ),
                      onTap: () {
                        ChatRoom.instance.cancelEdit();
                      })
                  : SizedBox(),
              Text(
                shortDateTime(widget.message.createdAt),
                style: TextStyle(fontSize: 8),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class CachedImage extends StatelessWidget {
  CachedImage(
    this.url, {
    this.width,
    this.height,
    this.onLoadComplete,
    this.fit = BoxFit.cover,
  });
  final String? url;
  final double? width;
  final double? height;
  final Function? onLoadComplete;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) {
    print('---> src: $url');
    if (url == null) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(
          Icons.error,
          size: 64,
        ),
      );
    }
    return CachedNetworkImage(
      imageBuilder: (context, provider) {
        // execute your onLoad code here
        // print("Image has been loaded!");
        if (onLoadComplete != null) Timer(Duration(milliseconds: 100), () => onLoadComplete!());
        // Return the image that has built by hand.
        return Image(image: provider, fit: fit);
      },
      imageUrl: url!,
      placeholder: (context, url) => Text('Loading Image'),
      errorWidget: (context, url, error) => Icon(Icons.error),
      width: width,
      height: height,
    );
  }
}
