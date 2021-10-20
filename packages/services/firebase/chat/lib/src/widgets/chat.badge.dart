import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/firebase_chat.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class ChatBadge extends StatefulWidget {
  const ChatBadge({Key? key}) : super(key: key);

  @override
  State<ChatBadge> createState() => _ChatBadgeState();
}

class _ChatBadgeState extends State<ChatBadge> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: chat.newMessages,
        builder: (c, snapshot) {
          if (snapshot.hasData == false) return SizedBox.shrink();
          return Badge(
            toAnimate: false,
            shape: BadgeShape.circle,
            badgeColor: Colors.red,
            elevation: 0,
            padding: EdgeInsets.all(3.0),
            badgeContent: Text(
              snapshot.data.toString(),
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
          );
        });
  }
}
