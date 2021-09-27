import 'dart:async';

import 'package:chat/chat.dart';
import 'package:chat/widgets/chat.message.bottom_actions.dart';
import 'package:chat/widgets/chat.message.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ChatMessageListWidget extends StatefulWidget {
  ChatMessageListWidget({
    this.onError,
    this.onPressUploadIcon,
    Key? key,
  }) : super(key: key);

  final Function? onError;
  final Function? onPressUploadIcon;

  @override
  _ChatMessageListWidgetState createState() => _ChatMessageListWidgetState();
}

class _ChatMessageListWidgetState extends State<ChatMessageListWidget> {
  var _tapPosition;

  bool loading = false;

  StreamSubscription? chatUserRoomSubscription;

  @override
  void initState() {
    super.initState();
    chatUserRoomSubscription = ChatRoom.instance.changes.listen((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    print('ChatRoomScreen::dispose()');
    chatUserRoomSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text('loading messages')
        : Column(
            children: [
              Expanded(
                child: KeyboardDismissOnTap(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    controller: ChatRoom.instance.scrollController,
                    itemCount: ChatRoom.instance.messages.length,
                    itemBuilder: (_, i) {
                      final message = ChatRoom.instance.messages[i];
                      return message.isMine ? myMessage(message) : otherMessage(message);
                    },
                  ),
                ),
              ),
              ChatMessageButtomActionsWidget(
                onError: widget.onError,
                onPressUploadIcon: widget.onPressUploadIcon,
              )
            ],
          );
  }

  Widget myMessage(message) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: ChatMessageViewWidget(message: message),
      onTapDown: _storePosition,
      onLongPress: () => onLongPressShowMenu(message),
    );
  }

  Widget otherMessage(message) {
    return ChatMessageViewWidget(message: message);
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void onLongPressShowMenu(message) {
    {
      final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
      showMenu(
        context: context,
        items: <PopupMenuEntry>[
          PopupMenuItem(
            value: "delete",
            child: Row(
              children: <Widget>[
                Icon(Icons.delete),
                Text("Delete"),
              ],
            ),
          ),
          PopupMenuItem(
            value: "edit",
            child: Row(
              children: <Widget>[
                Icon(Icons.edit),
                Text("Edit"),
              ],
            ),
          )
        ],
        position: RelativeRect.fromRect(
            _tapPosition & const Size(40, 40), // smaller rect, the touch area
            Offset.zero & overlay.size // Bigger rect, the entire screen
            ),
      ).then((value) {
        if (value == null) return;
        if (value == 'delete') {
          ChatRoom.instance.deleteMessage(message);
        }
        if (value == 'edit') {
          ChatRoom.instance.editMessage(message);
        }
      });
    }
  }
}
