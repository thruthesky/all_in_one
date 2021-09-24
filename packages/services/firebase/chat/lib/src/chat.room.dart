import 'package:chat/chat.dart';
import 'package:chat/src/chat.definitions.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:rxdart/rxdart.dart';
import 'chat.base.dart';

/// Chat room message list helper class.
///
/// By defining this helper class, you may open more than one chat room at the same time.
/// todo separate this class to `chat.dart`
class ChatRoom extends ChatBase {
  /// Api Singleton
  static ChatRoom? _instance;
  static ChatRoom get instance {
    if (_instance == null) {
      _instance = ChatRoom();
    }
    return _instance!;
  }

  // int _limit = 30;

  /// When the room information changes or there is new message, then [changes] will be posted.
  ///
  /// This event will be posted when
  /// - init with `null`
  /// - fetching messages(created, modified, updated), with the last chat message.
  ///   When there are messages from Firestore, there might be many message in one fetch, that's why it returns only last message.
  /// - sending a message, with the chat message to be sent.
  /// - cancelling for sending a message. `null` will be passed.
  // BehaviorSubject<ChatMessage> changes = BehaviorSubject.seeded(new ChatMessage());

  String? _displayName;

  String? get displayName => _displayName ?? loginUserUid;

  ChatUserRoom? currentRoom;

  ChatMessage? isMessageEdit;
  bool get isCreate => isMessageEdit == null;

  /// Enter chat room
  ///
  /// Null or empty string in [users] will be wiped out.
  ///
  Future<void> enter({required String firebaseUid, required String displayName}) async {
    _displayName = displayName;

    if (loginUserUid == null) {
      throw LOGIN_FIRST;
    }

    currentRoom = await getMyRoom(firebaseUid);
    print(currentRoom);

    if (currentRoom == null) {
      await ___create(firebaseUid);
    }

    // // fetch latest messages
    // fetchMessages();

    // // Listening current global room for changes and update.
    // if (_globalRoomSubscription != null) _globalRoomSubscription.cancel();

    // _globalRoomSubscription = globalRoomDoc(global.roomId).snapshots().listen((event) {
    //   global = ChatGlobalRoom.fromSnapshot(event);
    //   // print(' ------------> global updated; ');
    //   // print(global);
    //   globalRoomChanges.add(global);
    // });

    // // Listening current room document change event (in my room list).
    // //
    // // This will be notify the listener when chat room title changes, or new users enter, etc.
    // if (_currentRoomSubscription != null) _currentRoomSubscription.cancel();
    // _currentRoomSubscription = currentRoom.snapshots().listen((DocumentSnapshot doc) {
    //   if (doc.exists == false) {
    //     // User left the room. So the room does not exists.
    //     return;
    //   }

    //   // If the user got a message from a chat room where the user is currently in,
    //   // then, set `newMessages` to 0.
    //   final data = ChatUserRoom.fromSnapshot(doc);
    //   if (int.parse(data.newMessages) > 0 && data.createdAt != null) {
    //     currentRoom.update({'newMessages': 0});
    //   }
    // });

    // // fetch previous chat when user scrolls up
    // scrollController.addListener(() {
    //   // mark if scrolled up
    //   if (scrollUp) {
    //     scrolledUp = true;
    //   }
    //   // fetch previous messages
    //   if (scrollUp && atTop) {
    //     fetchMessages();
    //   }
    //   scrollChanges.add(scrollUp);
    // });

    // // Listen to keyboard
    // //
    // // When keyboard opens, scroll to bottom only if needed when user open/hide keyboard.
    // keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
    //   if (visible && atBottom) {
    //     scrollToBottom(ms: 10);
    //   }
    // });
  }

  Future<void> ___create(String firebaseUid) async {
    // String roomId = chatRoomId();
    // print('roomId: $roomId');

    final info = ChatUserRoom(
      id: firebaseUid,
      users: [firebaseUid, loginUserUid!],
      createdAt: ServerValue.timestamp,
    );
    await myRoomListCol.child(firebaseUid).set(info.data);

    currentRoom = ChatUserRoom.fromSnapshot(await myRoomListCol.child(firebaseUid).get());

    await sendMessage(
      text: ChatProtocol.roomCreated,
      displayName: displayName!,
    );
  }

  /// Send chat message to the users in the room
  ///
  /// [displayName] is the name that the sender will use. The default is
  /// `ff.user.displayName`.
  ///
  /// [photoURL] is the sender's photo url. Default is `ff.user.photoURL`.
  ///
  /// [type] is the type of the message. It can be `image` or `text` if string only.
  Future<Map<String, dynamic>> sendMessage({
    required String text,
    required String displayName,
    Map<String, dynamic>? extra,
    String photoURL = '',
  }) async {
    if (displayName.trim() == '') {
      throw CHAT_DISPLAY_NAME_IS_EMPTY;
    }

    Map<String, dynamic> message = {
      'senderUid': loginUserUid,
      'senderDisplayName': displayName,
      'senderPhotoURL': photoURL,
      'text': text,

      // Make [newUsers] empty string for re-setting(removing) from previous
      // message.
      'newUsers': [],

      if (extra != null) ...extra,
    };

    if (isCreate) {
      // Time that this message(or last message) was created.
      message['createdAt'] = ServerValue.timestamp;

      await messagesCol(currentRoom!.id).push().set(message);
      // print(message);
      message['newMessages'] = ServerValue.increment(1); // To increase, it must be an udpate.
      List<Future<void>> messages = [];

      /// Just incase there are duplicated UIDs.
      List<String> roomUsers = [...currentRoom!.users!.toSet()];

      /// Send a message to all users in the room.
      for (String uid in roomUsers) {
        // print(chatUserRoomDoc(uid, info['id']).path);
        messages.add(userRoomDoc(uid, currentRoom!.id).update(message));
      }
      // print('send messages to: ${messages.length}');
      await Future.wait(messages);
    } else {
      message['updatedAt'] = ServerValue.timestamp;
      await messagesCol(currentRoom!.id).child(isMessageEdit!.id).update(message);
      isMessageEdit = null;
    }

    return message;
  }
}
