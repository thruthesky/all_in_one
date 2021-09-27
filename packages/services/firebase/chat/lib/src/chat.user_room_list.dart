import 'dart:async';

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
  BehaviorSubject changes = BehaviorSubject.seeded('');

  StreamSubscription? _myRoomListSubscription;

  List<StreamSubscription> _roomSubscriptions = [];

  /// Login user's whole room list including room id.
  List<ChatUserRoom> rooms = [];

  int newMessages = 0;

  bool fetched = false;

  /// Listen to global room updates.
  ///
  /// Listen for;
  /// - title changes,
  /// - users array changes,
  /// - and other properties change.
  _listenRoomList() {
    _myRoomListSubscription = myRoomListCol.onValue.listen((event) {
      fetched = true;
      Map<dynamic, dynamic>? res = event.snapshot.value;
      if (res != null) {
        rooms = [];
        res.forEach((key, data) {
          rooms.add(ChatUserRoom.fromData(data, key));
        });
      }
      changes.add('');
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
