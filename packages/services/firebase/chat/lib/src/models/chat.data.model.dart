import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/firebase_chat.dart';

class ChatDataModel {
  String text;
  Timestamp timestamp;
  int newMessages;
  String to;
  String from;

  String get time =>
      DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch).toLocal().toString();

  /// 나의 Firebase UID 를 리턴한다. 이것은 ChatService 에 이미 초기화되어져 있는 것이다.
  String get myUid => ChatService.instance.user.uid;

  /// 문서(메시지)에는 보낸이(from) 와 받는이(to) 가 있는데, 어떤 것이 나의(로그인 사용자의) firebase uid 인지 알 수 없다.
  /// 그래서, 아래와 같이 나의 firebase uid 를 입력 받아,
  /// 상대방의 firebase uid 를 리턴한다.
  String get otherUid {
    return to == myUid ? from : to;
  }

  /// 내가 보낸 메시지이면 true 를 리턴한다.
  bool get byMe => from == myUid;
  bool get isMine => byMe;

  /// 상대방이 보낸 메시지면, true 를 리턴한다.
  bool get byOther => to == myUid;

  bool get hasNewMessage => newMessages > 0;

  DocumentReference get otherUserRoomInMyRoomListRef => chat.roomsCol.doc(otherUid);

  /// Reference of this document (chat model data)
  DocumentReference? ref;

  bool get isImage {
    String t = text.toLowerCase();
    if (t.endsWith('.jpg')) return true;
    if (t.endsWith('.jpeg')) return true;
    if (t.endsWith('.png')) return true;
    if (t.endsWith('.gif')) return true;
    return false;
  }

  /// It may be a link of file upload on backend, or simply a text typed by user.
  /// App should do 'canLunch', or 'url launch' to display the url.
  bool get isUrl {
    String t = text.toLowerCase();
    return t.startsWith('http://') || t.startsWith('https://');
  }

  /// Return true if the message is not uploaded image or file, nor a url typed by user.
  bool get isText {
    return isImage == false && isUrl == false;
  }

  ChatDataModel({
    required this.to,
    required this.from,
    required this.text,
    required this.timestamp,
    required this.newMessages,
    required this.ref,
  });

  factory ChatDataModel.fromJson(Map<dynamic, dynamic> json, [DocumentReference? ref]) {
    return ChatDataModel(
      to: json['to'] ?? '',
      from: json['from'] ?? '',
      text: json['text'] ?? '',
      timestamp: json['timestamp'] ?? Timestamp.now(), // 이 부분에서 exception 이 발생한다.
      newMessages: json['newMessages'] ?? 0,
      ref: ref,
    );
  }

  toJson() {
    return {
      'to': to,
      'from': from,
      'text': text,
      'timestamp': timestamp,
      'newMessages': newMessages,
    };
  }

  @override
  String toString() {
    return """ChatDataModel(${toJson()})""";
  }

  /// Deletes other user in my room list.
  Future<void> deleteOtherUserRoom() {
    return otherUserRoomInMyRoomListRef.delete();
  }

  /// Deletes current document.
  /// It may be a chat message or room info.
  Future<void> delete() {
    return ref!.delete();
  }

  Future<void> update(String text) {
    return ref!.set({'text': text}, SetOptions(merge: true));
  }
}
