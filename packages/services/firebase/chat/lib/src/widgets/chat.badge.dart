import 'package:firebase_chat/firebase_chat.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class ChatBadge extends StatelessWidget {
  const ChatBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chat.newMessages,
      builder: (c, snapshot) {
        if (snapshot.hasData == false) return SizedBox.shrink();
        int no = int.tryParse((snapshot.data ?? '0').toString()) ?? 0;
        return Badge(
          toAnimate: false,
          shape: BadgeShape.circle,
          badgeColor: no == 0 ? Colors.grey : Colors.red,
          elevation: 0,
          padding: EdgeInsets.all(3.0),
          badgeContent: Text(
            no.toString(),
            style: TextStyle(color: Colors.white, fontSize: 8),
          ),
        );
      },
    );
  }
}
