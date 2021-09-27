import 'dart:async';
import 'dart:convert';

import 'package:chat/chat.dart';
import 'package:chat/src/chat.definitions.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
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
      _instance = ChatRoom._internal();
    }
    return _instance!;
  }

  ChatRoom._internal() {
    _notifySubjectSubscription =
        _notifySubject.debounceTime(Duration(milliseconds: 50)).listen((x) {
      changes.add(null);
    });
  }

  String? _displayName;

  String? get displayName => _displayName ?? loginUserUid;

  ChatUserRoom? currentRoom;

  ChatMessage? isMessageEdit;
  bool get isCreate => isMessageEdit == null;

  /// [loading] becomes true while the app is fetching more messages.
  /// The app should display loader while it is fetching.
  bool loading = false;

  /// When user scrolls to top to view previous messages, the app fires the scroll event
  /// too much, so it fetches too many batches(pages) at one time.
  /// [_throttle] reduces the scroll event to relax the fetch racing.
  /// [_throttle] is working together with [_throttling]
  /// 1500ms is recommended.
  int _throttle = 1500;
  bool _throttling = false;

  int page = 0;
  int _limit = 30;

  /// upload progress
  double progress = 0;

  /// [noMoreMessage] becomes true when there is no more old messages to view.
  /// The app should display 'no more message' to user.
  bool noMoreMessage = false;

  /// Loaded the chat messages of current chat room.
  List<ChatMessage> messages = [];

  StreamSubscription? _currentRoomSubscription;
  StreamSubscription? _childAddedSubscription;
  // StreamSubscription? _childChangedSubscription;
  // StreamSubscription? _childRemovedSubscription;

  final textController = TextEditingController();
  final scrollController = ScrollController();

  /// Scrolls down to the bottom when,
  /// * chat room is loaded (only one time.)
  /// * when I chat,
  /// * when new chat is coming and the page is scrolled near to bottom. Logically it should not scroll down when the page is scrolled far from the bottom.
  /// * when keyboard is open and the page scroll is near to bottom. Locally it should not scroll down when the user is reading message that is far from the bottom.
  scrollToBottom({int ms = 100}) {
    /// This is needed to safely scroll to bottom after chat messages has been added.
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (scrollController.hasClients)
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: ms), curve: Curves.ease);
    });
  }

  /// When the room information changes or there is new message, then [changes] will be posted.
  ///
  /// This event will be posted when
  /// - init with `null`
  /// - fetching messages(created, modified, updated), with the last chat message.
  ///   When there are messages from Firestore, there might be many message in one fetch, that's why it returns only last message.
  /// - sending a message, with the chat message to be sent.
  /// - cancelling for sending a message. `null` will be passed.
  BehaviorSubject<ChatMessage?> changes = BehaviorSubject.seeded(null);

  PublishSubject _notifySubject = PublishSubject();
  StreamSubscription? _notifySubjectSubscription;

  /// Enter chat room
  ///
  /// Null or empty string in [users] will be wiped out.
  ///
  Future<void> enter({required String otherFirebaseUid, required String displayName}) async {
    _displayName = displayName;

    if (loginUserUid == null) {
      throw LOGIN_FIRST;
    }

    List<String> users = [otherFirebaseUid, loginUserUid!];
    users.sort();
    String uids = users.join('');
    String _id = md5.convert(utf8.encode(uids)).toString();
    currentRoom = await getMyRoom(_id);
    print(currentRoom);

    if (currentRoom == null) {
      await ___create(roomId: _id, otherFirebaseUid: otherFirebaseUid);
    }

    // fetch latest messages
    fetchMessages();

    // Listening current room in my room list.
    // This will be notify chat room listener when chat room title changes, or new users enter, etc.
    if (_currentRoomSubscription != null) _currentRoomSubscription?.cancel();
    _currentRoomSubscription = myRoom(currentRoom!.roomId).onValue.listen((Event event) {
      // If the user got a message from a chat room where the user is currently in,
      // then, set `newMessages` to 0.
      final data = ChatUserRoom.fromSnapshot(event.snapshot);
      if (int.parse(data.newMessages) > 0 && data.createdAt != null) {
        myRoom(currentRoom!.roomId).update({'newMessages': 0});
      }
    });

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

  Future<void> ___create({required String roomId, required otherFirebaseUid}) async {
    final info = ChatUserRoom(
      users: [otherFirebaseUid, loginUserUid!],
      senderDisplayName: _displayName!,
      senderUid: loginUserUid!,
      createdAt: ServerValue.timestamp,
    );
    // create current user room
    await myRoomListCol.child(roomId).set(info.data);
    // get current user room
    currentRoom = ChatUserRoom.fromSnapshot(await myRoomListCol.child(roomId).get());
    // create other user room
    await userRoomDoc(otherFirebaseUid, roomId).set(info.data);
    // send initial create room message
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

      await messagesCol(currentRoom!.roomId).push().set(message);
      // print(message);
      message['newMessages'] = ServerValue.increment(1); // To increase, it must be an udpate.
      List<Future<void>> messages = [];

      /// Just incase there are duplicated UIDs.
      List<String> roomUsers = [...currentRoom!.users!.toSet()];

      /// Send a message to all users in the room.
      for (String uid in roomUsers) {
        // print(chatUserRoomDoc(uid, info['id']).path);
        messages.add(userRoomDoc(uid, currentRoom!.roomId).update(message));
      }

      // print('send messages to: ${messages.length}');
      await Future.wait(messages);
    } else {
      message['updatedAt'] = ServerValue.timestamp;
      await messagesCol(currentRoom!.roomId).child(isMessageEdit!.id).update(message);
      isMessageEdit = null;
    }

    return message;
  }

  /// Fetch previous messages
  fetchMessages() async {
    if (_throttling || noMoreMessage) return;
    loading = true;
    _throttling = true;

    page++;
    if (page == 1) {
      final ref = myRoom(currentRoom!.roomId);
      // print('ref: ${ref.path}');
      await ref.update({'newMessages': 0});
    }

    /// Get messages for the chat room
    Query q = messagesCol(currentRoom!.roomId).orderByKey();

    if (messages.isNotEmpty) {
      q = q.endAt(messages.first.createdAt);
    }

    q = q.limitToLast(_limit);

    _childAddedSubscription = q.onChildAdded.listen((Event event) {
      loading = false;
      Timer(Duration(milliseconds: _throttle), () => _throttling = false);

      // print(event.snapshot.value);
      final _message = event.snapshot.value;
      _message['id'] = event.snapshot.key;

      ChatMessage message = ChatMessage.fromData(event.snapshot.value, id: event.snapshot.key!);

      /// On first page, just add chats at the bottom.
      if (page == 1) {
        messages.add(message);
      } else if (message.createdAt >= messages.last.createdAt) {
        /// On new chat, just add at bottom.
        messages.add(message);
      } else {
        /// On previous chat, add chat messages on top, but with the order of chat messages.
        for (int i = 0; i < messages.length; i++) {
          if (message.createdAt <= messages[i].createdAt) {
            messages.insert(i, message);
            break;
          }
        }
      }

      // if it is loading old messages
      // check if it is the very first message.
      if (message.createdAt != null) {
        if (message.text == ChatProtocol.roomCreated) {
          noMoreMessage = true;
          print('-----> noMoreMessage: $noMoreMessage');
        }
      }
      _notify();
    });
  }

  /// Notify chat room listener to re-render the screen.
  /// Render may happen too much. Reduce it.
  _notify() {
    _notifySubject.add(null);
  }

  unsubscribe() {
    _notifySubjectSubscription?.cancel();
    _currentRoomSubscription?.cancel();
    _childAddedSubscription?.cancel();
    // _childChangedSubscription.cancel();
    // _childRemovedSubscription.cancel();
  }

  bool isMessageOnEdit(ChatMessage message) {
    if (isCreate) return false;
    if (!message.isMine) return false;
    return message.id == isMessageEdit!.id;
  }

  cancelEdit() {
    textController.text = '';
    isMessageEdit = null;
    changes.add(null);
  }

  editMessage(ChatMessage message) {
    print('editMessage');
    textController.text = message.text;
    isMessageEdit = message;
    changes.add(message);
  }

  deleteMessage(ChatMessage message) {
    messagesCol(currentRoom!.roomId).child(message.id).remove();
  }
}
