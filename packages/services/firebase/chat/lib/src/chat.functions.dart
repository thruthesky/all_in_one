String getMyUid(String roomId) {
  return roomId.split('__').first;
}

String getOtherUid(String roomId) {
  return roomId.split('__').last;
}

/// Chat room ID
///
/// - Return chat room id of login user and the other user.
/// - The location of chat room is at `/rooms/[ID]`.
/// - Chat room ID is composited with login user UID and other user UID by alphabetic order.
///   - If myFirebaseUid = 3 and otherUserFirebaseUid = 4, then the result is "3-4".
///   - If myFirebaseUid = 321 and otherUserFirebaseUid = 1234, then the result is "1234-321"
String getMessageCollectionId(String myFirebaseUid, String otherUserFirebaseUid) {
  return myFirebaseUid.compareTo(otherUserFirebaseUid) < 0
      ? "${myFirebaseUid}__$otherUserFirebaseUid"
      : "${otherUserFirebaseUid}__$myFirebaseUid";
}
