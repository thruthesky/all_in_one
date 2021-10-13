import 'package:firebase_chat/firebase_chat.dart';

class ChatService {
  /// Singleton
  static ChatService? _instance;
  static ChatService get instance {
    if (_instance == null) {
      _instance = ChatService();
    }
    return _instance!;
  }

  /// Login user information
  /// If uid is empty, the user is not logged in.
  ChatLoginUser user = ChatLoginUser(uid: '', name: '', photoUrl: '');

  /// Update current login user informatoin
  ///
  /// This method can be invoked many times to update user information lively.
  updateUser({String uid = '', String name = '', String photoUrl = ''}) {
    user.uid = uid;
    user.name = name;
    user.photoUrl = photoUrl;
  }

  /// Chat room ID
  ///
  /// - Return chat room id of login user and the other user.
  /// - The location of chat room is at `/rooms/[ID]`.
  /// - Chat room ID is composited with login user UID and other user UID by alphabetic order.
  ///   - If user.uid = 3 and otherUserUid = 4, then the result is "3-4".
  ///   - If user.uid = 321 and otherUserUid = 1234, then the result is "1234-321"
  String getRoomId(String otherUserUid) {
    print('re: ${user.uid.compareTo(otherUserUid)}');
    return user.uid.compareTo(otherUserUid) < 0
        ? "${user.uid}_$otherUserUid"
        : "${otherUserUid}_${user.uid}";
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
