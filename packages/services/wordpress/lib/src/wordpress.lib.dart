import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

int toInt(dynamic text) {
  if (text == null) return 0;
  if (text is num) return text.toInt();
  return int.tryParse(text) ?? 0;
}

String toStr(dynamic thing) {
  if (thing == null) return '';
  if (thing is String) return thing;
  if (thing is bool) return '';

  return thing.toString();
}

bool toBool(dynamic thing) {
  if (thing is bool) return thing;
  if (thing is String && thing == 'true') return true;
  return false;
}

/// Returns absolute file path from the relative path.
/// [path] must include the file extension.
/// @example
/// ``` dart
/// localFilePath('photo/baby.jpg');
/// ```
Future<String> getAbsoluteTemporaryFilePath(String relativePath) async {
  var directory = await getTemporaryDirectory();
  return p.join(directory.path, relativePath);
}

/// Returns a random string
///
///
String getRandomString({int len = 16, String? prefix}) {
  const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
  var t = '';
  for (var i = 0; i < len; i++) {
    t += charset[(Random().nextInt(charset.length))];
  }
  if (prefix != null && prefix.isNotEmpty) t = prefix + t;
  return t;
}

/// Returns filename with extension.
///
/// @example
///   `/root/users/.../abc.jpg` returns `abc.jpg`
///
String getFilenameFromPath(String path) {
  return path.split('/').last;
}

/// Convert youtube link into embeded HTML to display youtube video in HTML
String convertYoutubeLinkToEmbedHTML(String str) {
  return str.replaceAllMapped(
    RegExp(
        r"http(?:s?):\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-\_]*)(&(amp;)?‌​[\w\?‌​=]*)?"),
    (match) {
      return """
      <video id="${match.group(0)}" src="${match.group(0)}"></video>
      """;
      // return """
      // <p>
      // <iframe width="100%" height="160" src="${match.group(0)}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
      // </p>
      // """;
    },
  );
}

/// Check if a string has youtube link.
bool hasYoutubeLink(String str) {
  return RegExp(
          r"http(?:s?):\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-\_]*)(&(amp;)?‌​[\w\?‌​=]*)?")
      .hasMatch(str);
}

// Return youtube id.
String getYoutubeId(String url, {bool trimWhitespaces = true}) {
  /// if url is youtube id itself,
  if (!url.contains("http") && (url.length == 11)) return url;
  //
  if (trimWhitespaces) url = url.trim();

  for (final exp in [
    RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ]) {
    RegExpMatch? match = exp.firstMatch(url);
    // print('url; $url, match; $match\n--\n');
    if (match != null && match.groupCount >= 1) return match.group(1)!;
  }
  return '';
}
