import 'package:chat/chat.dart';
import 'package:chat/models/chat.user_room.model.dart';
import 'package:chat/src/chat.function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoomListItemWidget extends StatefulWidget {
  ChatRoomListItemWidget(
    this.room, {
    this.onTap,
    this.avatar,
  });

  final ChatUserRoom room;
  final Function? onTap;

  final Widget Function(String)? avatar;

  @override
  _ChatRoomListItemWidgetState createState() => _ChatRoomListItemWidgetState();
}

class _ChatRoomListItemWidgetState extends State<ChatRoomListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: widget.avatar != null ? widget.avatar!(ChatUserRoomList.instance.userInfo!['url']) : null,
      title: Text(
        widget.room.roomId,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.room.text,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${shortDateTime(widget.room.createdAt)}",
            // style: subtitle1,
          ),
          Spacer(),
          if (widget.room.newMessages != '' && int.parse(widget.room.newMessages) > 0)
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 24),
              child: Chip(
                labelPadding: EdgeInsets.fromLTRB(4, -4, 4, -4),
                label: Text(
                  '${widget.room.newMessages}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.red,
              ),
            ),
          Spacer(),
        ],
      ),
      onTap: () {
        if (widget.onTap != null) widget.onTap!();
      },
    );
  }
}
