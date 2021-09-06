import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_flutter/x_flutter.dart';

/// Upload image v2.
/// v1 is in `packages/widgets/lib/src/file/uploaded_image.dart`.
///
/// This image widget is for uploading an image with taxonomy, entity, code.
///   - So, it is good for any file/image upload with code. like user profile photo, shopping mall photo.
///   - t is not for forum file upload.
///
/// This image can delete previously uploaded photo.
///
/// If [deletePreviousUpload] is set to true, then it deletes previously uploaded photo.
///
/// [child] is the image to display. This is the deference from v1.
///
/// [choiceBuilder] is to display the choice to upload image from camera, or gallery.
///
///
///
///
class UploadImageV2 extends StatefulWidget {
  const UploadImageV2({
    Key? key,
    this.taxonomy = '',
    this.entity = 0,
    this.code = '',
    this.quality = 95,
    this.deletePreviousUpload = false,
    required this.child,
    required this.choiceBuilder,
    this.uploaded,
    this.progress,
    required this.error,
  }) : super(key: key);

  final String taxonomy;
  final int entity;
  final String code;
  final Function choiceBuilder;
  final int quality;
  final Function? progress;
  final bool deletePreviousUpload;
  final Widget child;
  final Function error;
  final Function? uploaded;

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImageV2> {
  FileModel? fileModel;

  @override
  void initState() {
    super.initState();
    () async {
      try {
        /// Note, for the first time, when user has not uploaded his profile photo yet, `entity_not_found` error will happen and it can be ignored.
        fileModel = await FileApi.instance
            .get(taxonomy: widget.taxonomy, entity: widget.entity, code: widget.code);
        setState(() {});
      } catch (e) {
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
          fileModel = await FileApi.instance.pickUpload(
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
      child: widget.child,
      behavior: HitTestBehavior.opaque,
    );
  }
}
