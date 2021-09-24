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
  BehaviorSubject<ChatUserRoom> changes = BehaviorSubject.seeded(new ChatUserRoom());

  StreamSubscription? _myRoomListSubscription;
  Map<String, StreamSubscription> _roomSubscriptions = {};

  /// Login user's whole room list including room id.
  List<ChatUserRoom> rooms = [];
  String _order = "createdAt";

  int newMessages = 0;

  _reset({String? order}) {
    if (order != null) {
      _order = order;
    }
    newMessages = 0;
    rooms = [];
    if (_myRoomListSubscription != null) {
      _myRoomListSubscription!.cancel();
      _myRoomListSubscription = null;
    }
  }

  /// Listen to global room updates.
  ///
  /// Listen for;
  /// - title changes,
  /// - users array changes,
  /// - and other properties change.
  _listenRoomList() {
    // _myRoomListSubscription =
    //     myRoomListCol.orderBy(_order, descending: true).snapshots().listen((snapshot) {
    //   snapshot.docChanges.forEach((DocumentChange documentChange) {
    //     final roomInfo = ChatUserRoom.fromSnapshot(documentChange.doc);

    //     // print(roomInfo.newMessages);
    //     if (documentChange.type == DocumentChangeType.added) {
    //       rooms.add(roomInfo);

    //       /// When room list is retreived for the first, it will be added to listener.
    //       /// This is where [changes] event happens many times when the app listens to room list.
    //       _roomSubscriptions[roomInfo.id] = globalRoomDoc(roomInfo.id).snapshots().listen(
    //         (DocumentSnapshot snapshot) {
    //           int found = rooms.indexWhere((r) => r.id == roomInfo.id);
    //           rooms[found].global = ChatGlobalRoom.fromSnapshot(snapshot);
    //           // print('global room has changed. ${rooms[found]}');
    //           changes.add(rooms[found]);
    //         },
    //       );
    //     } else if (documentChange.type == DocumentChangeType.modified) {
    //       int found = rooms.indexWhere((r) => r.id == roomInfo.id);
    //       // If global room information exists, copy it to updated object to
    //       // maintain global room information.
    //       final global = rooms[found].global;
    //       rooms[found] = roomInfo;
    //       rooms[found].global = global;
    //     } else if (documentChange.type == DocumentChangeType.removed) {
    //       final int i = rooms.indexWhere((r) => r.id == roomInfo.id);
    //       if (i > -1) {
    //         rooms.removeAt(i);
    //       }
    //     } else {
    //       assert(false, 'This is error');
    //     }
    //   });

    //   newMessages = 0;
    //   rooms.forEach((roomInfo) {
    //     newMessages += int.parse(roomInfo.newMessages);
    //   });

    //   /// post event with last room

    //   changes.add(snapshot.docChanges.length > 0
    //       ? ChatUserRoom.fromSnapshot(snapshot.docChanges.last.doc)
    //       : null);
    // });
  }

  _unsubscribe() {
    // if (_myRoomListSubscription != null) _myRoomListSubscription.cancel();
    // if (_roomSubscriptions.isNotEmpty) {
    //   for (final key in _roomSubscriptions.keys) {
    //     _roomSubscriptions[key].cancel();
    //   }
    //   _roomSubscriptions = {};
    // }
    // newMessages = 0;
  }

  unsubscribeUserRoom(ChatUserRoom room) {
    // if (_roomSubscriptions.isEmpty) return;
    // if (_roomSubscriptions[room.roomId] == null) return;

    // _roomSubscriptions[room.roomId].cancel();
    // _roomSubscriptions.removeWhere((String key, dynamic value) => key == room.roomId);
  }
}
