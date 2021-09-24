import 'package:chat/chat.dart';
import 'package:chat/src/chat.room.dart';

/// [ChatMessage] presents the chat message under
/// `/chat/messages/{roomId}/{messageId}` collection.
///
/// [isImage] returns bool if the message is image or not.
class ChatMessage {
  String id;
  String createdAt;
  List<String>? newUsers;
  String senderDisplayName;
  String senderPhotoURL;
  String senderUid;
  String text;
  bool isMine;
  bool isImage;
  Map<String, dynamic>? data;
  bool rendered = false;

  ChatMessage({
    this.id = '',
    this.createdAt = '',
    this.newUsers,
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

  factory ChatMessage.fromData(Map<String, dynamic> data, {required String id}) {
    bool isImage = false;
    if (data['text'] != null && isImageUrl(data['text'])) {
      isImage = true;
    }
    return ChatMessage(
      id: data['id'] ?? id ?? '',
      createdAt: data['createdAt'],
      newUsers: List<String>.from(data['newUsers'] ?? []),
      senderDisplayName: data['senderDisplayName'] ?? '',
      senderPhotoURL: data['senderPhotoURL'] ?? '',
      senderUid: data['senderUid'] ?? '',
      text: data['text'] ?? '',
      isMine: data['senderUid'] == ChatRoom.instance.loginUserUid,
      isImage: isImage,
      data: data,
    );
  }
}
