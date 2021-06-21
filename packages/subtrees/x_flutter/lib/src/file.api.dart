import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_flutter/src/defines.dart';
import 'package:x_flutter/src/functions.dart';
import 'package:x_flutter/src/models/file.model.dart';
import 'package:x_flutter/x_flutter.dart';

class FileApi {
  Api get api => Api.instance;

  /// 사진업로드
  ///
  ///
  /// 이미지를 카메라 또는 갤러리로 부터 가져와서, 이미지 누어서 찍힌 이미지를 바로 보정을 하고, 압축을 하고, 서버에 업로드
  /// [deletePreviousUpload] 가 true 이면, 기존에 업로드된 동일한 taxonomy 와 entity 파일을 삭제한다.
  ///
  /// 참고로, 사용자에게 사진을 카메로 가져오거나 갤러리로 부터 가져오는지 물어보려면, `UploadImage` 위젯을 사용하거나
  /// `UploadImage` 안의 로직을 복사해서 사용한다.
  ///
  Future<dynamic> pickUpload({
    required ImageSource source,
    int quality = 90,
    bool deletePreviousUpload = false,
    String taxonomy = '',
    int entity = 0,
    String code = '',
    Function? progress,
  }) async {
    /// Pick image
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: source);
    print('pickedFile; $pickedFile');
    if (pickedFile == null) throw IMAGE_NOT_SELECTED;

    print('compress with: ${pickedFile.path}');
    File file = await imageCompressor(pickedFile.path, quality);

    print('code: $code in api.controller.dart::takeUploadfile');

    /// Upload with file
    return await upload(
      file: file,
      deletePreviousUpload: deletePreviousUpload,
      progress: progress,
      taxonomy: taxonomy,
      entity: entity,
      code: code,
    );
  }

  /// 파일을 압축하고, 가로/세로를 맞춘다.
  imageCompressor(String filepath, int quality) async {
    /// This method will be called when image was taken by [Api.takeUploadFile].
    /// It can compress the image and then return it as a File object.

    String localFile = await getAbsoluteTemporaryFilePath(getRandomString() + '.jpeg');
    File? file = await FlutterImageCompress.compressAndGetFile(
      filepath, // source file
      localFile, // target file. Overwrite the source with compressed.
      quality: quality,
    );

    return file;
  }

  /// 사진 업로드
  ///
  /// 사용자에게 물어보지 않고, 파일만 주면 바로 업로드한다.
  Future<FileModel> upload({
    required File file,
    Function? progress,
    bool deletePreviousUpload = false,
    String taxonomy = '',
    int entity = 0,
    String code = '',
  }) async {
    FormData formData;

    ///
    formData = FormData.fromMap({
      /// `route` 와 `session_id` 등 추가 파라메타 값을 전달 할 수 있다.
      'route': 'file.upload',
      'sessionId': api.sessionId,
      'taxonomy': taxonomy,
      'entity': entity.toString(),
      'code': code,
      'deletePreviousUpload': deletePreviousUpload ? 'Y' : 'N',

      /// 아래에서 `userfile` 이, `$_FILES[userfile]` 와 같이 들어간다.
      'userfile': await MultipartFile.fromFile(
        file.path,

        /// `filename` 은 `$_FILES[userfile][name]` 와 같이 들어간다.
        filename: getFilenameFromPath(file.path),
        contentType: MediaType('image', 'jpeg'),
      ),
    });

    final dio = Dio();
    final res = await dio.post(
      api.url,
      data: formData,
      onSendProgress: (int sent, int total) {
        if (progress != null) progress(sent * 100 / total);
      },
    );

    // print('res: $res');
    // print(jsonEncode(res.data.response));

    /// @todo  merge this error handling with [request]
    if (res.data is String || res.data['response'] == null) {
      throw (res.data);
    } else if (res.data['response'] is String) {
      throw res.data['response'];
    }
    // print('file upload susccess;');
    // print(res.data['response']);
    // return ApiFile.fromJson(res.data['response']);
    return FileModel.fromJson(res.data['response']);
  }

  /// 파일 정보를 가져온다.
  Future<FileModel> get({String taxonomy = '', int entity = 0, String code = ''}) async {
    final res = await Api.instance
        .request('file.get', {'taxonomy': taxonomy, 'entity': entity, 'code': code});

    return FileModel.fromJson(res);
  }

  /// Deletes a file.
  ///
  /// [idx] is the file idx to delete.
  /// [postOrComment] is a post or a comment that the file is attached to.
  /// If [postOrComment] is given, then the file will be removed from the `files` array after deletion.
  ///
  /// It returns deleted file id.
  Future<FileModel> delete(int idx, [dynamic postOrComment]) async {
    final res = await api.request('file.delete', {'idx': idx});
    if (postOrComment != null) {
      int i = postOrComment.files.indexWhere((file) => file.idx == idx);
      if (i > -1) {
        postOrComment.files.removeAt(i);
      }
    }
    return FileModel.fromJson(res);
  }
}
