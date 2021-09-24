import 'package:chat/chat.dart';
import 'package:firebase_database/firebase_database.dart';

/// [ChatUserRoom] is for documents of `/chat/rooms/{user-id}` collection.
class ChatUserRoom {
  String id;
  String senderUid;
  String senderDisplayName;
  String senderPhotoURL;
  String text;
  List<String>? users;
  List<String>? moderators;
  List<String>? blockedUsers;
  List<String>? newUsers;

  /// [createAt] is the time that last message was sent by a user.
  /// It will be `FieldValue.serverTimestamp()` when it sends the
  /// message. And it will `Timestamp` when it read the room information.
  String createdAt;

  /// [newMessages] has the number of new messages for that room.
  String newMessages;

  bool isImage;

  ChatUserRoom({
    this.id = '',
    this.senderUid = '',
    this.senderDisplayName = '',
    this.senderPhotoURL = '',
    this.users,
    this.moderators,
    this.blockedUsers,
    this.newUsers,
    this.text = '',
    this.createdAt = '',
    this.newMessages = '',
    this.isImage = false,
  });

  factory ChatUserRoom.fromSnapshot(DataSnapshot snapshot) {
    if (snapshot.exists == false) return new ChatUserRoom();
    Map<String, dynamic> info = snapshot.value;
    return ChatUserRoom.fromData(info, snapshot.key!);
  }

  factory ChatUserRoom.fromData(Map<String, dynamic>? info, String id) {
    if (info == null) return ChatUserRoom();

    String _text = info['text'];

    bool isImage = false;
    if (isImageUrl(_text)) {
      isImage = true;
    }
    return ChatUserRoom(
      id: id,
      senderUid: info['senderUid'],
      senderDisplayName: info['senderDisplayName'],
      senderPhotoURL: info['senderPhotoURL'],
      users: List<String>.from(info['users'] ?? []),
      moderators: List<String>.from(info['moderators'] ?? []),
      blockedUsers: List<String>.from(info['blockedUsers'] ?? []),
      newUsers: List<String>.from(info['newUsers'] ?? []),
      createdAt: info['createdAt'],
      text: _text,
      newMessages: "${info['newMessages']}",
      isImage: isImage,
    );
  }

  Map<String, dynamic> get data {
    return {
      'id': id,
      'senderUid': senderUid,
      'senderDisplayName': senderDisplayName,
      'senderPhotoURL': senderPhotoURL,
      'users': this.users,
      'moderators': this.moderators,
      'blockedUsers': this.blockedUsers,
      'newUsers': this.newUsers,
      'text': this.text,
      'createdAt': this.createdAt,
      'newMessages': this.newMessages,
    };
  }

  @override
  String toString() {
    return data.toString();
  }
}
