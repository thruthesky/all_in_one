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

  // text(ChatMessage message) {
  //   String text = message.text ?? '';

  //   if (text == ChatProtocol.roomCreated) {
  //     text = message.senderDisplayName + '님이 채팅방을 개설했습니다.';
  //   }
  //   if (text == ChatProtocol.add) {
  //     text = message.senderDisplayName + ' added ' + message.newUsers.join(',');
  //   }
  //   if (text == ChatProtocol.kickout) {
  //     text = message.senderDisplayName + ' kicked ' + message.data['userName'];
  //   }
  //   if (text == ChatProtocol.block) {
  //     text = message.senderDisplayName + ' block  ' + message.data['userName'];
  //   }

  //   if (text == ChatProtocol.addModerator) {
  //     text = message.senderDisplayName + ' add moderator ' + message.data['userName'];
  //   }
  //   if (text == ChatProtocol.removeModerator) {
  //     text = message.senderDisplayName + ' remove moderator ' + message.data['userName'];
  //   }

  //   if (text == ChatProtocol.titleChanged) {
  //     text = message.senderDisplayName + ' change room title ';
  //     text += message.data['newTitle'] != null ? 'to ' + message.data['newTitle'] : '';
  //   }

  //   if (text == ChatProtocol.enter) {
  //     // print(message);
  //     text = "${message.senderDisplayName} invited ${message.newUsers}";
  //   }
  //   return text;
  // }

}
