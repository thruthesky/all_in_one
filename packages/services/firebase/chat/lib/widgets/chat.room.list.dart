import 'dart:async';

import 'package:chat/models/chat.user_room.model.dart';
import 'package:chat/src/chat.user_room_list.dart';
import 'package:chat/widgets/chat.room.list.item.dart';
import 'package:flutter/widgets.dart';

class ChatRoomListWidget extends StatefulWidget {
  ChatRoomListWidget({
    required this.onChatRoomTap,
  });

  final Function onChatRoomTap;
  @override
  _ChatRoomListWidgetState createState() => _ChatRoomListWidgetState();
}

class _ChatRoomListWidgetState extends State<ChatRoomListWidget> {
  StreamSubscription? chatUserRoomSubscription;

  @override
  void initState() {
    super.initState();
    chatUserRoomSubscription = ChatUserRoomList.instance.changes.listen((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    print('_ChatRoomListWidgetState::chatUserRoomSubscription::dispose()');
    chatUserRoomSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final rooms = ChatUserRoomList.instance.rooms;
    return rooms.length > 0
        ? ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (_, i) {
              final ChatUserRoom room = rooms[i];
              return ChatRoomListItemWidget(room, onTap: () {
                widget.onChatRoomTap(room);
              });
            },
          )
        : Center(
            child: Text('No Chats...'),
          );
  }
}
