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

  /// [createAt] is the time that last message was sent by a user.
  /// It will be `ServerValue.timestamp` when it sends the
  /// message. And it will `Timestamp` when it read the room information.
  Map<String, String>? createdAt;

  /// [newMessages] has the number of new messages for that room.
  String newMessages;

  bool isImage;

  ChatUserRoom({
    this.id = '',
    this.senderUid = '',
    this.senderDisplayName = '',
    this.senderPhotoURL = '',
    this.users,
    this.text = '',
    this.createdAt,
    this.newMessages = '',
    this.isImage = false,
  });

  factory ChatUserRoom.fromSnapshot(DataSnapshot snapshot) {
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
