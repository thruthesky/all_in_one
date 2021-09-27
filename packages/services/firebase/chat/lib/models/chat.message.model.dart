import 'package:chat/chat.dart';
import 'package:chat/src/chat.room.dart';

/// [ChatMessage] presents the chat message under
/// `/chat/messages/{roomId}/{messageId}` collection.
///
/// [isImage] returns bool if the message is image or not.
class ChatMessage {
  String id;
  dynamic createdAt;
  String senderDisplayName;
  String senderPhotoURL;
  String senderUid;
  String text;
  bool isMine;
  bool isImage;
  Map<Object?, Object?>? data;
  bool rendered = false;

  ChatMessage({
    this.id = '',
    this.createdAt,
    this.senderDisplayName = '',
    this.senderPhotoURL = '',
    this.senderUid = '',
    this.text = '',
    this.isMine = false,
    this.isImage = false,
    this.data,
  });
  bool get isMovie {
    final String t = text.toLowerCase();
    if (t.startsWith('http') && (t.endsWith('.mov') || t.endsWith('.mp4'))) return true;
    return false;
  }

  factory ChatMessage.fromData(Map<Object?, Object?> data, {required String id}) {
    bool isImage = false;
    if (data['text'] != null && isImageUrl(data['text'] as String)) {
      isImage = true;
    }
    return ChatMessage(
      id: id,
      createdAt: data['createdAt'],
      senderDisplayName: data['senderDisplayName'] as String,
      senderPhotoURL: data['senderPhotoURL'] as String,
      senderUid: data['senderUid'] as String,
      text: data['text'] as String,
      isMine: data['senderUid'] == ChatRoom.instance.loginUserUid,
      isImage: isImage,
      data: data,
    );
  }
}
