import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

/// Download file or data from the Internet and cache it locally.
///
/// It can be used in multiple places with same file name. One option is not to
/// pass the file name, so the file name will be automatically set.
///
/// [url] is the url to download.
/// [filename] is the file name to save.
/// It is optional. If it is not set, then it will get the file name from url.
/// I will take the last 64 letters from the end of the url and use it after escaping.
/// [dirPath] is the directory path to save the file.
/// if it is not set, then the file will be saved in temporary folder
/// [expiration] is the time interval to download the file again.
///   if it is `expiration: Duration(minutes: 500)`, then it will download again after 500 minutes. default is 365 days (a year)
/// [onDownloadBegin], [onDownloadEnd], [onDownloadProgress] are the callback on downloda events. If the file has already downloaded and not expired, then the callbacks will be not called.
/// [onDownloadProgress] will be called with -1 if the downloadable size is not known from the backend. onDownloadProgress has three params. first int is for percentage, second int is for how many bytes received, and the third int is for total. If the total is -1, then display the received bytes on screen.
/// The progress percentage is mostly working with binary data download.
///
/// It returns the file path as String type.
///
/// You may wrap with try/catch to handle uncaught exceptions.
///
/// An example of getting text(or html) from web server.
/// ```dart
/// final path = await download(
///   'https://philgo.com',
///   filename: 'philgo-index.html',
///   expiration: Duration(seconds: 10),
///   onDownloadProgress: (int p, int received, int total) =>
///     print('p: $p, recevied: $received, total: $total'),
/// );
/// print(json);
/// ```
///
/// An example of getting json and decoding
/// ```dart
/// final path = await download(
///   'https://simple-test-api.com/abc.json',
///   filename: 'seoul_art_exhibition.json',
///   expiration: Duration(minutes: 10),
///   onDownloadProgress: (int p, int received, int total) =>
///     print('p: $p, recevied: $received, total: $total'),
/// );
/// print( jsonDecode(json) );
/// ```
///
/// Example of getting image from webserver and cache it for 5 days
/// ```
/// imagePath = await download(
///   'https://file.philgo.com/data/upload/0/2292660',
///    filename: 'seoul.jpg',
///    expiration: Duration(days: 5),
///    onDownloadProgress: (p, r, t) => print('p: $p'),
/// );
/// Image.asset(imagePath!),
/// ```

Future<String> download(
  String url, {
  Duration expiration = const Duration(days: 365),
  String? filename,
  String? dirPath,
  Function? onDownloadBegin,
  Function? onDownloadEnd,
  Function? onDownloadProgress,
}) async {
  /// Get file path
  if (dirPath == null) {
    Directory tempDir = await getTemporaryDirectory();
    dirPath = tempDir.path;
  }
  if (filename == null) {
    filename = url.length > 64 ? url.substring(url.length - 64) : url;
    filename = safeFilename(filename);
  }
  String pathToSave = dirPath + '/' + filename;

  print('download: $pathToSave');

  /// Check if file exists,
  File file = File(pathToSave);
  bool re = file.existsSync();

  if (re) {
    print('---- yes, file exists');
    // Yes, file exists. Then, check if the file is older than expiration
    DateTime now = DateTime.now();
    DateTime lastModifiedDateTime = file.lastModifiedSync();
    DateTime expire = lastModifiedDateTime.add(expiration);

    // The downloaded file has already expired?
    if (expire.compareTo(now) < 0) {
      print('---- yes, downloaded file is expired');
      await _downloadUrl(url, pathToSave,
          onDownloadBegin: onDownloadBegin,
          onDownloadEnd: onDownloadEnd,
          onDownloadProgress: onDownloadProgress);
    }
  } else {
    // No, file not exists. Download.
    print('---- No, file not exists. Download.');
    await _downloadUrl(url, pathToSave,
        onDownloadBegin: onDownloadBegin,
        onDownloadEnd: onDownloadEnd,
        onDownloadProgress: onDownloadProgress);
  }

  return pathToSave;

  /// Read the file
  // file = File(pathToSave);
  // re = await file.exists();
  // if (re == false) {
  //   throw ('ERROR_FAILED_TO_LOAD_TEMPORARY_FILE');
  // }

  // /// Return the content of the file.
  // return file.readAsBytesSync();
}

_downloadUrl(
  String url,
  String path, {
  Function? onDownloadBegin,
  Function? onDownloadEnd,
  Function? onDownloadProgress,
}) async {
  print('---- download begins ---- _downloadUrl()');
  if (onDownloadBegin != null) onDownloadBegin();
  Dio dio = Dio();
  final response = await dio.get(
    url,
    onReceiveProgress: (received, total) {
      if (onDownloadProgress == null) return;
      if (total == -1) {
        onDownloadProgress(-1, received, -1);
      } else {
        int p = (received / total * 100).round();
        onDownloadProgress(p, received, total);
      }
    },
    // List<int> 로 받기 위해서, 이 옵션 필수.
    // 이렇게 하지 않으면, writeFromSync() 에서 InternalLinkedHashMap<String, dynamic> is not a subtype of type List<int> 에러가 난다.
    options: Options(
      responseType: ResponseType.bytes,
      followRedirects: false,
    ),
  );

  File file = File(path);

  /// It saves the data into the file as `List<int>`.
  final raf = file.openSync(mode: FileMode.write);
  raf.writeFromSync(response.data);
  raf.closeSync();

  if (onDownloadEnd != null) onDownloadEnd();
}

/// from https://github.com/2n-1/safe_filename
String safeFilename(
  String filename, {
  String separator = '-',
  bool withSpaces = false,
  bool lowercase = false,
  bool onlyAlphanumeric = false,
}) {
  final List<String> reservedCharacters = [
    '?',
    ':',
    '"',
    '*',
    '|',
    '/',
    '\\',
    '<',
    '>',
    '+',
    '[',
    ']',
  ];

  final RegExp onlyAlphanumericRegex = RegExp(r'''[^a-zA-Z0-9\s.]''');

  String returnString = filename;
  onlyAlphanumeric
      ? returnString = returnString.replaceAll(onlyAlphanumericRegex, '')
      : reservedCharacters.forEach((c) {
          returnString = returnString.replaceAll(c, separator);
        });
  if (!withSpaces) returnString = returnString.replaceAll(' ', separator);
  return lowercase ? returnString.toLowerCase() : returnString;
}
