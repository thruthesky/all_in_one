import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class FilePlayPage extends StatefulWidget {
  final _file;
  FilePlayPage(this._file);

  @override
  _FilePlayPageState createState() => _FilePlayPageState();
}

class _FilePlayPageState extends State<FilePlayPage> {
  late Track track;

  @override
  void initState() {
    super.initState();

    track =
        Track(trackPath: widget._file.toString().substring(7, widget._file.toString().length - 1));
  }

  @override
  Widget build(BuildContext context) {
    var player = SoundPlayerUI.fromTrack(track);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget._file
            .toString()
            .substring(widget._file.toString().length - 25, widget._file.toString().length - 1)),
      ),
      body: Column(
        children: [player],
      ),
    );
  }
}
