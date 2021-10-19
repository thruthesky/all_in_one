import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/firebase_chat.dart';
import 'package:rxdart/rxdart.dart';

class ChatService {
  /// Singleton
  static ChatService? _instance;
  static ChatService get instance {
    if (_instance == null) {
      _instance = ChatService();
    }

    return _instance!;
  }

  /// The Firebase UID of the user in the currently opened chat room.
  ///
  /// [otherUid] is the other user's Firebase UID on the current chat room.
  /// Note that, [user] is the login user's information and [otherUid] is the other user firebase uid on currently opened chat room.
  /// App may use it to check who the login user is talking to.
  /// For instance, if login use is talking to someone in current chat room, then the app can ignore push messages from the user.
  String otherUid = '';

  /// Post [ready] event when user information is set.
  /// You may use it to know if app is ready to send chat message in a chat room.
  BehaviorSubject<bool> ready = BehaviorSubject.seeded(false);

  /// Login user information
  /// If uid is empty, the user is not logged in.
  ChatLoginUser user = ChatLoginUser(uid: '', name: '', photoUrl: '');

  /// Update current login user informatoin
  ///
  /// This method can be invoked many times to update user information lively.
  /// [uid] must be Firebase UID
  updateUser({String uid = '', String name = '', String photoUrl = ''}) {
    user.uid = uid;
    user.name = name;
    user.photoUrl = photoUrl;
    if (user.uid != '') {
      ready.add(true);
    }
  }

  /// Chat room ID
  ///
  /// - Return chat room id of login user and the other user.
  /// - The location of chat room is at `/rooms/[ID]`.
  /// - Chat room ID is composited with login user UID and other user UID by alphabetic order.
  ///   - If user.uid = 3 and otherUserFirebaseUid = 4, then the result is "3-4".
  ///   - If user.uid = 321 and otherUserFirebaseUid = 1234, then the result is "1234-321"
  String getRoomId(String otherUserFirebaseUid) {
    return getMessageCollectionId(user.uid, otherUserFirebaseUid);
  }

  /// 내 방 목록(컬렉션)을 리턴한다.
  ///
  /// 참고, user.uid 가 설정된 후 이 함수가 호출되어야 한다.
  /// ```
  /// chat.roomsCol.orderBy('timestamp', descending: true);
  /// ```
  CollectionReference get roomsCol =>
      FirebaseFirestore.instance.collection('chat/rooms/${user.uid}');

  /// Returns other user's room list collection
  CollectionReference otherUserRoomsCol(String otherUserUid) {
    return FirebaseFirestore.instance.collection('chat/rooms/$otherUserUid');
  }

  /// Check if both of the user id(s) in chat room id belong to himself.
  /// If so, the user is trying to chat with himself.
  /// And chat to himself may be a useful feature. See readme.
  ///
  /// - To block a user to chat himself, you may do this.
  /// ```dart
  /// if (ChatService.instance.chatWithMySelf(roomId)) {
  ///   return alert('ooh', 'You cannot chat with yourself.');
  /// }
  /// ```
  bool chatWithMySelf(String roomId) {
    return roomId.split('_').first == roomId.split('_').last;
  }
}
