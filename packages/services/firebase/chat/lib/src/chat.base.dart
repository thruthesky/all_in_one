import 'package:chat/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatBase {
  String? get loginUserUid =>
      FirebaseAuth.instance.currentUser == null ? null : FirebaseAuth.instance.currentUser!.uid;

  bool get isLogin => FirebaseAuth.instance.currentUser != null;
  FirebaseDatabase get db => FirebaseDatabase.instance;

  /// Returns login user's room list collection `/chat/my-room-list/{my-uid}` reference.
  ///
  ///
  DatabaseReference get myRoomListCol {
    return userRoomListCol(loginUserUid!);
  }

  /// Return the collection of messages of the room id.
  DatabaseReference messagesCol(String roomId) {
    return db.reference().child('chat/messages').child(roomId);
  }

  /// Returns my room list collection `/chat/user-rooms/{uid}` reference.
  ///
  DatabaseReference userRoomListCol(String userId) {
    return db.reference().child('chat/user-rooms').child(userId);
  }

  /// Returns my room (that has last message of the room) document
  /// reference.
  DatabaseReference userRoomDoc(String userId, String roomId) {
    return userRoomListCol(userId).child(roomId);
  }

  /// Returns document reference of my room (that has last message of the room)
  ///
  /// `/chat/user-rooms/uid/{roomId}`
  DatabaseReference myRoom(String roomId) {
    return myRoomListCol.child(roomId);
  }

  Future<ChatUserRoom?> getMyRoom(String roomId) async {
    DataSnapshot snapshot = await myRoom(roomId).get();
    if (snapshot.exists == false) return null;
    return ChatUserRoom.fromSnapshot(snapshot);
  }

  text(ChatMessage message) {
    String text = message.text;

    if (text == ChatProtocol.roomCreated) {
      text = message.senderDisplayName + ' has opened a chat room.';
    }

    if (text == ChatProtocol.titleChanged) {
      text = message.senderDisplayName + ' change room title ';
      text += message.data!['newTitle'] != null ? 'to ' + message.data!['newTitle'] : '';
    }

    if (text == ChatProtocol.enter) {
      text = "${message.senderDisplayName} invited ${message.newUsers}";
    }
    return text;
  }
}
