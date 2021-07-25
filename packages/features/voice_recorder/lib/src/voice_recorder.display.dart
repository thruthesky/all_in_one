import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widgets/widgets.dart';
import 'file_list_page.dart';

class VoiceRecorderDisplay extends StatefulWidget {
  const VoiceRecorderDisplay({Key? key}) : super(key: key);

  @override
  _VoiceRecorderDisplayState createState() => _VoiceRecorderDisplayState();
}

class _VoiceRecorderDisplayState extends State<VoiceRecorderDisplay> {
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  bool _isRecorderInited = false;
  String _path = '';
  String _fileName = '';
  List<dynamic> _fileNameList = [];

  // typedef Func = void Function;

  @override
  void initState() {
    super.initState();
    getFileNameList();
    _openTheRecord();
  }

  @override
  void dispose() {
    super.dispose();

    _recorder!.closeAudioSession();
    _recorder = null;
  }

  Future<String> get _localPath async {
    final appDir = await getApplicationDocumentsDirectory();

    String temp = appDir.path + '/recordings';

    var directory = await io.Directory(temp).create();

    return directory.path;
  }

  void getFileNameList() async {
    var filePath = await _localPath;
    setState(() {
      _fileNameList = io.Directory('$filePath/').listSync();
    });
  }

  Future<void> _openTheRecord() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _recorder!.openAudioSession();
    _isRecorderInited = true;
  }

  void _record() async {
    _path = await _localPath;
    _fileName = '$_path/${DateTime.now().toString().replaceAll(RegExp(r'\D'), '')}.acc';
    print('_fileName; $_fileName');
    _recorder!.startRecorder(toFile: _fileName).then((value) => setState(() {}));
  }

  void _stopRecorder() async {
    await _recorder!.stopRecorder().then((value) => setState(() {}));
    getFileNameList();
  }

  void startOrStopRecording() {
    if (!_isRecorderInited) {
      return;
    }
    _recorder!.isStopped ? _record() : _stopRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: startOrStopRecording,
          child: Padding(
            padding: const EdgeInsets.all(xl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _recorder!.isRecording ? Icons.stop : Icons.circle,
                  color: _recorder!.isRecording ? Colors.grey : Colors.red,
                ),
                SizedBox(width: xs),
                Text(_recorder!.isRecording ? '녹음 중입니다' : '버튼을 누르시면 녹음됩니다')
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: sm),
                  child: Text('녹화된 파일 목록'),
                ),
                Expanded(
                  child: FileListPage(_fileNameList),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
