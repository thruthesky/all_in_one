import 'package:chat/chat.dart';
import 'package:firebase_database/firebase_database.dart';

/// [ChatUserRoom] is for documents of `/chat/rooms/{user-id}` collection.
class ChatUserRoom {
  String roomId;
  String senderUid;
  String senderDisplayName;
  String senderPhotoURL;
  String text;
  List<String>? users;

  /// [createAt] is the time that last message was sent by a user.
  /// It will be `ServerValue.timestamp` when it sends the
  /// message. And it will `Timestamp` when it read the room information.
  // ignore: unnecessary_question_mark
  dynamic? createdAt;

  /// [newMessages] has the number of new messages for that room.
  String newMessages;

  bool isImage;

  ChatUserRoom({
    this.roomId = '',
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
    Map<Object?, Object?> info = snapshot.value;
    return ChatUserRoom.fromData(info, snapshot.key!);
  }

  factory ChatUserRoom.fromData(Map<Object?, Object?>? info, String roomId) {
    if (info == null) return ChatUserRoom();

    String _text = info['text'] as String;

    bool isImage = false;
    if (isImageUrl(_text)) {
      isImage = true;
    }
    return ChatUserRoom(
      roomId: roomId,
      senderUid: info['senderUid'] as String,
      senderDisplayName: info['senderDisplayName'] as String,
      senderPhotoURL: info['senderPhotoURL'] as String,
      users: List<String>.from(info['users'] as Iterable<dynamic>),
      createdAt: info['createdAt'] as int,
      text: _text,
      newMessages: "${info['newMessages']}",
      isImage: isImage,
    );
  }

  Map<String, dynamic> get data {
    return {
      'id': roomId,
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
