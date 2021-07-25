import 'package:utils/utils.dart';
import 'package:widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:widgets/widgets.dart';

class FileListPage extends StatefulWidget {
  final List<dynamic> _fileNameList;
  FileListPage(this._fileNameList);

  @override
  _FileListPageState createState() => _FileListPageState();
}

class _FileListPageState extends State<FileListPage> {
  void _deleteFile(int index) async {
    final file = widget._fileNameList[index];
    if (await file.exists()) {
      await file.delete();
    } else {
      print('There is no such file');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget._fileNameList.length == 0) {
      return Padding(
        padding: EdgeInsets.all(sm),
        child: Text('녹화된 파일이 없습니다.'),
      );
    }
    return Container(
      child: ListView.builder(
        itemCount: widget._fileNameList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget._fileNameList[index].path.split('/').last),
            onTap: () => Get.toNamed('voiceRecorderPlayer',
                arguments: {'file': widget._fileNameList[index]}),
            // {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => FilePlayerPage(widget._fileNameList[index])));
            // },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                final fileName = widget._fileNameList.elementAt(index);
                final re = await confirm('녹음 파일 삭제', '선택한 파일 - $fileName - 을 삭제하시겠습니까?');
                if (re) {
                  _deleteFile(index);
                  widget._fileNameList.removeAt(index);
                  setState(() {});
                }
              },
            ),
          );
        },
      ),
    );
  }
}
