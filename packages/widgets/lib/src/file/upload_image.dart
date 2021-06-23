import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_flutter/x_flutter.dart';

/// 사진 업로드
///
/// 이 위젯은 하나의 사진을 업로드하고, 수정할 때 사용하는 것으로 글/코멘트에서 여러 사진을 올리려면 다른 위젯을 사용해야 한다.
/// 하지만, 위 젯을 글/코멘트에 쓸 때에는 code 별로 하나의 사진을 나타내고, 업데이트 하는 경우 사용하면 된다.
///
/// 특정 taxonomy, entity, code 에 맞춰서 사진을 올린다. 기존의 업로드된 사진을 덮어 쓸 수 있다.
///
/// [deletePreviousUpload] 가 true 이면, 기존의 업로드된 이미지를 덮어 쓴다.
///
/// [defaultChild] 는 업로드된 사진이 없는 경우, 기본적으로 보여줄 위젯.
/// [imageBuilder] 는 이미 업로드된 이미지가 있는 경우 또는 새로운 이미지가 업로드된 경우, 그 표시를 하기 위해서 build 를 하는 것.
///
/// [choiceBuilder] 는 업로드를 할 때, 카메라로 부터 사진을 가져올지, 갤러리에서 사진을 가져올지 선택하는, ImageSource 를 리턴해야 한다.
/// 일반적으로 팝업 다이얼로그나 Bootsheet 를 보여주고, 사용자에게 갤러리에서 사진을 가져올지, 카메라로 사진을 찍을지 선택하게하면 된다.
///
///
///
class UploadImage extends StatefulWidget {
  const UploadImage({
    Key? key,
    this.taxonomy = '',
    this.entity = 0,
    this.code = '',
    this.quality = 95,
    this.deletePreviousUpload = false,
    this.defaultChild,
    required this.imageBuilder,
    required this.choiceBuilder,
    this.uploaded,
    this.progress,
    required this.error,
  }) : super(key: key);

  final String taxonomy;
  final int entity;
  final String code;
  final Function imageBuilder;
  final Function choiceBuilder;
  final int quality;
  final Function? progress;
  final bool deletePreviousUpload;
  final Widget? defaultChild;
  final Function error;
  final Function? uploaded;

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  FileModel? fileModel;

  @override
  void initState() {
    super.initState();
    () async {
      try {
        /// 주의: 회원 로그인이 필요한 경우, Api 에서 sessionId 가 초기화 된 후 호출 되어야 함. 그렇지 않으면 entity_not_found 에러 발생.
        fileModel = await Api.instance.file
            .get(taxonomy: widget.taxonomy, entity: widget.entity, code: widget.code);
        setState(() {});
      } catch (e) {
        // 아직 사진이 업로드되지 않은 경우, 패스
        if (e == ENTITY_NOT_FOUND) {
        } else {
          widget.error(e);
        }
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          ImageSource? re = await widget.choiceBuilder(context);
          if (re == null) return;
          fileModel = await Api.instance.file.pickUpload(
            source: re,
            quality: widget.quality,
            progress: widget.progress,
            taxonomy: widget.taxonomy,
            entity: widget.entity,
            code: widget.code,
            deletePreviousUpload: widget.deletePreviousUpload,
          );
          setState(() {});
          if (widget.uploaded != null) widget.uploaded!(fileModel);
        } catch (e) {
          widget.error(e);
        }
      },
      child: fileModel != null ? widget.imageBuilder(fileModel) : defaultChild(),
    );
  }

  defaultChild() {
    if (widget.defaultChild != null) return widget.defaultChild;

    return Text('Upload Image');
  }
}
