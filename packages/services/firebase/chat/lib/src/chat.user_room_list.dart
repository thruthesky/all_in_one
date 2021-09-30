import 'dart:async';
import 'dart:collection';

import 'package:chat/models/chat.user_room.model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:chat/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Chat room list helper class
///
/// This is a completely independent helper class to help to list login user's room list.
/// You may rewrite your own helper class.
class ChatUserRoomList extends ChatBase {
  /// Api Singleton
  static ChatUserRoomList? _instance;
  static ChatUserRoomList get instance {
    if (_instance == null) {
      _instance = ChatUserRoomList._internal();
    }
    return _instance!;
  }

  ChatUserRoomList._internal() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _unsubscribe();
      } else {
        _reset();
        _listenRoomList();
      }
    });
  }

  // Function __render;

  /// This event is posted with a room info when
  /// - gets all the room list of user when it first run. The last room will be passed over.
  /// - and when there is new chat, user room will be modified, so, this event will be passed over again with the room that has chagned.
  /// - When global room information changes. it will pass the user room of the global room.
  ///
  /// To get the whole list of room info, use [rooms].
  BehaviorSubject<List<ChatUserRoom>?> changes = BehaviorSubject.seeded(null);

  StreamSubscription? _myRoomListSubscription;

  List<StreamSubscription> _roomSubscriptions = [];

  /// Login user's whole room list including room id.
  List<ChatUserRoom> rooms = [];
  Map<String, Map<String, String>> userInfo = {};

  int newMessages = 0;

  bool fetched = false;

  otherUserProfileUrl(ChatUserRoom room) {
    String? uid = otherUsersUid(room.users);
    if (uid == null) return '';
    if (userInfo[uid] == null) return '';
    if (userInfo[uid]!.isEmpty) return '';
    if (userInfo[uid]!['url'] != null) return userInfo[uid]!['url'];
    return '';
  }

  otherUserProfileName(ChatUserRoom room) {
    String? uid = otherUsersUid(room.users);
    if (uid == null) return room.roomId;
    if (userInfo[uid] == null) return room.roomId;
    if (userInfo[uid]!.isEmpty) return room.roomId;
    if (userInfo[uid]!['displayName'] != null) return userInfo[uid]!['displayName'];
    return room.roomId;
  }

  /// Listen to global room updates.
  ///
  /// Listen for;
  /// - title changes,
  /// - users array changes,
  /// - and other properties change.
  _listenRoomList() {
    _myRoomListSubscription = myRoomListCol.orderByChild('updatedAt').onValue.listen((event) {
      fetched = true;
      Map<dynamic, dynamic>? res = event.snapshot.value;
      if (res != null) {
        rooms = [];
        res = LinkedHashMap.fromEntries(res.entries.toList().reversed);
        res.forEach((key, data) {
          ChatUserRoom room = ChatUserRoom.fromData(data, key);
          rooms.add(room);
          String? otherUid = otherUsersUid(room.users);
          if (otherUid != null && userInfo[otherUid] == null) userInfo[otherUid] = {};
        });
      }
      changes.add(rooms);
    });
  }

  _reset() {
    newMessages = 0;
    rooms = [];
    if (_myRoomListSubscription != null) {
      _myRoomListSubscription?.cancel();
      _myRoomListSubscription = null;
    }
    _listenRoomList();
  }

  _unsubscribe() {
    if (_myRoomListSubscription != null) _myRoomListSubscription?.cancel();
    if (_roomSubscriptions.isNotEmpty) {
      _roomSubscriptions.forEach((element) {
        element.cancel();
      });
    }
  }
}
