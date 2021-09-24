import 'dart:async';

import 'package:chat/models/chat.user_room.model.dart';
import 'package:chat/src/chat.user_room_list.dart';
import 'package:chat/widgets/chat.room.list.item.dart';
import 'package:flutter/widgets.dart';

class ChatRoomList extends StatefulWidget {
  ChatRoomList({
    required this.onChatRoomTap,
  });

  final Function onChatRoomTap;
  @override
  _ChatRoomListState createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  StreamSubscription? chatUserRoomListSubscription;

  @override
  void initState() {
    super.initState();

    /// When any of the login user's rooms changes, it will be handled here.
    chatUserRoomListSubscription = ChatUserRoomList.instance.changes.listen((rooms) {
      print('ChatRoomList:: room list change;');
      // print(ChatUserRoomList.instance.rooms);
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    print('ChatRoomScreen::dispose()');
    chatUserRoomListSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final rooms = ChatUserRoomList.instance.rooms;
    return rooms.length > 0
        ? ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (_, i) {
              final ChatUserRoom room = rooms[i];
              return ChatRoomListItem(room, onTap: () {
                widget.onChatRoomTap(room);
              });
            },
          )
        : Center(
            child: Text('No Chats...'),
          );
  }
}
