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
  /// 이미지를 카메라 또는 갤러리로 부터 가져와서, 이미지 누어서 찍힌 이미지를 바로 보정을 하고, 압축을 하고, 서버에 업로드
  /// [deletePreviousUpload] 가 true 이면, 기존에 업로드된 동일한 taxonomy 와 entity 파일을 삭제한다.
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

  Future<FileModel> upload({
    required File file,
    Function? progress,
    bool deletePreviousUpload = false,
    String taxonomy = '',
    int entity = 0,
    String code = '',
  }) async {
    FormData formData;

    /// [Prefix] 를 쓰는 이유는 Dio 의 FromData 와 Flutter 의 기본 HTTP 와 충돌하기 때문이다.
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

  Future<FileModel> get({String taxonomy = '', int entity = 0, String code = ''}) async {
    final res = await Api.instance
        .request('file.get', {'taxonomy': taxonomy, 'entity': entity, 'code': code});

    return FileModel.fromJson(res);
  }
}
