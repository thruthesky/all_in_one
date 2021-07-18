import 'package:flutter/material.dart';
import 'file_play_page.dart';

class FileListPage extends StatefulWidget {
  final List<dynamic> _fileNameList;
  FileListPage(this._fileNameList);

  @override
  _FileListPageState createState() => _FileListPageState();
}

class _FileListPageState extends State<FileListPage> {
  void _deleteFile(int index) async {
    var file = widget._fileNameList[index];
    if (await file.exists()) {
      await file.delete();
    } else {
      print('There is no such file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget._fileNameList);
          },
        ),
      ),
      body: Container(
          child: ListView.builder(
              itemCount: widget._fileNameList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget._fileNameList[index].toString().substring(
                      widget._fileNameList[index].toString().length - 25,
                      widget._fileNameList[index].toString().length - 1)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FilePlayPage(widget._fileNameList[index])));
                  },
                  onLongPress: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('선택한 파일을 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _deleteFile(index);
                                    widget._fileNameList.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('삭제되었습니다.'),
                                    duration: Duration(milliseconds: 1000),
                                  ));
                                  Navigator.pop(context);
                                },
                                child: Text('OK'))
                          ],
                        );
                      }),
                );
              })),
    );
  }
}
