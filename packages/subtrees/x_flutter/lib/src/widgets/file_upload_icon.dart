import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_flutter/x_flutter.dart';

/// 파일(사진) 업로드
///
/// 글/코멘트 처럼 여러개의 파일을 업로드 할 때 사용하는 것으로 내부적으로 상태관리를 하지 않는다.
/// 즉, 파일 업로드를 하면, [success] 콜백으로 알려주고, 에러가 있으면 [error] 콜백으로 알려준다.
/// 파일 업로드 상태는 [progress] 로 알려주고, 사용자가 버튼을 클릭하면, [choiceBuilder] 로
/// 카메라 또는 갤러리에서 사진을 가져올지 정한다.
class FileUploadIcon extends StatelessWidget {
  const FileUploadIcon({
    Key? key,
    required this.success,
    required this.error,
    required this.progress,
    this.choiceBuilder,
    this.taxonomy = 'posts',
    this.entity = 0,
    this.quality = 90,
  }) : super(key: key);

  final Function success;
  final Function error;
  final Function progress;
  final Function? choiceBuilder;
  final String taxonomy;
  final int entity;
  final int quality;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          try {
            ImageSource? re = await _choiceBuilder(context);
            if (re == null) return;
            FileModel f = await Api.instance.file.pickUpload(
              source: re,
              quality: quality,
              progress: progress,
              taxonomy: taxonomy,
              entity: entity,
            );
            print('file upload: f: $f');
            success(f);
          } catch (e) {
            error(e);
          }
        },
        icon: Icon(Icons.camera_alt));
  }

  _choiceBuilder(BuildContext context) async {
    if (choiceBuilder != null) return await choiceBuilder!(context);
    final re = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: new Icon(Icons.camera_alt),
                  title: new Text('카메라로 사진 찍기'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.photo),
                  title: new Text('앨범에서 사진 가져오기'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.cancel),
                  title: new Text('취소'),
                  onTap: () {
                    Navigator.pop(context, null);
                  },
                ),
              ],
            ),
          );
        });
    print('choice: re: $re');
    return re;
    // return Get.bottomSheet(Container(
    //   color: Colors.white,
    //   child: SafeArea(
    //     child: Wrap(children: <Widget>[
    //       ListTile(
    //           leading: Icon(Icons.camera_alt),
    //           title: Text('카메라로 사진찍어 올리기'),
    //           onTap: () => Get.back(result: ImageSource.camera)),
    //       ListTile(
    //           leading: Icon(Icons.photo),
    //           title: Text('갤러리에서 사진 가져오기'),
    //           onTap: () => Get.back(result: ImageSource.gallery)),
    //       ListTile(leading: Icon(Icons.cancel), title: Text('취소'), onTap: () => Get.back()),
    //     ]),
    //   ),
    // ));
  }
}
