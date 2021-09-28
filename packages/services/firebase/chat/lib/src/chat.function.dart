import 'package:chat/chat.dart';
import 'package:intl/intl.dart';

bool isImageUrl(String? t) {
  if (t == null || t == '') return false;
  if (t.startsWith('http://') || t.startsWith('https://')) {
    if (t.endsWith('.jpg') ||
        t.endsWith('.jpeg') ||
        t.endsWith('.gif') ||
        t.endsWith('.png') ||
        t.contains('f=jpg') ||
        t.contains('f=jpeg') ||
        t.contains('f=gif') ||
        t.contains('f=png')) {
      return true;
    }
  }
  return false;
}

List<String> otherUsersUid(List<String>? users) {
  if (users == null) return [];
  return users.where((uid) => uid != ChatRoom.instance.loginUserUid).toList();
}

String shortDateTime(dynamic dt) {
  /// If it's firestore `FieldValue.serverTimstamp()`, the event may be fired
  /// twice.
  if (dt == null) {
    return '';
  }
  DateTime time = DateTime.fromMillisecondsSinceEpoch(dt);
  DateTime today = DateTime.now();
  if (time.year == today.year && time.month == today.month && time.day == today.day) {
    return DateFormat.jm().format(time);
  }
  return DateFormat('dd/MM/yy').format(time);
}
