import 'package:chat/models/chat.user_room.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatRoomListItem extends StatefulWidget {
  ChatRoomListItem(
    this.room, {
    this.onTap,
  });

  final ChatUserRoom room;
  final Function? onTap;

  @override
  _ChatRoomListItemState createState() => _ChatRoomListItemState();
}

class _ChatRoomListItemState extends State<ChatRoomListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: UserAvatar(
      //   widget.room.profilePhotoUrl ?? '',
      // ),
      title: Text(
        widget.room.id,
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
          if (int.parse(widget.room.newMessages) > 0)
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

  String shortDateTime(dynamic dt) {
    /// If it's firestore `FieldValue.serverTimstamp()`, the event may be fired
    /// twice.
    if (dt == null) {
      return '';
    }
    DateTime time = DateTime.fromMillisecondsSinceEpoch(dt.seconds * 1000);
    DateTime today = DateTime.now();
    if (time.year == today.year && time.month == today.month && time.day == today.day) {
      return DateFormat.jm().format(time);
    }
    return DateFormat('dd/MM/yy').format(time);
  }
}
