import 'package:chat/chat.dart';
import 'package:chat/src/chat.definitions.dart';
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
}
