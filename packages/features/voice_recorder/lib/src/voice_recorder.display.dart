import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorderDisplay extends StatefulWidget {
  const VoiceRecorderDisplay({Key? key}) : super(key: key);

  @override
  _VoiceRecorderDisplayState createState() => _VoiceRecorderDisplayState();
}

class _VoiceRecorderDisplayState extends State<VoiceRecorderDisplay> {
  FlutterSoundPlayer? _player = FlutterSoundPlayer();
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  bool _isPlayerInited = false;
  bool _isRecorderInited = false;
  bool _isPlaybackReady = false;
  final String _path = 'voice_recorder_example.aac';

  @override
  void initState() {
    super.initState();

    _player!.openAudioSession().then((value) => setState(() {
          _isPlayerInited = true;
        }));

    _openTheRecord();
  }

  @override
  void dispose() {
    super.dispose();

    _player!.closeAudioSession();
    _player = null;
    _recorder!.closeAudioSession();
    _recorder = null;
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

  void _record() {
    _recorder!.startRecorder(toFile: _path).then((value) => setState(() {}));
  }

  void _stopRecorder() async {
    await _recorder!.stopRecorder().then((value) => setState(() {
          _isPlaybackReady = true;
        }));
  }

  void _play() {
    assert(_isPlayerInited && _isPlaybackReady && _recorder!.isStopped && _player!.isStopped);
    _player!.startPlayer(fromURI: _path, whenFinished: () => setState(() {}));
  }

  void _stopPlayer() {
    _player!.stopPlayer().then((value) => setState(() {}));
  }

  void _getRecorder() {
    if (!_isRecorderInited || !_player!.isStopped) {
      return;
    }
    _recorder!.isStopped ? _record() : _stopRecorder();
  }

  void _getPlayback() {
    if (!_isPlayerInited || !_isPlaybackReady || !_recorder!.isStopped) {
      return;
    }
    _player!.isStopped ? _play() : _stopPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                icon: Icon(_recorder!.isRecording ? Icons.stop : Icons.circle),
                color: _recorder!.isRecording ? Colors.grey : Colors.red,
                onPressed: () {
                  _getRecorder();
                }),
            Text(_recorder!.isRecording ? '녹음 중입니다' : '버튼을 누르시면 녹음됩니다')
          ],
        ),
        Row(
          children: [
            IconButton(
                icon: Icon(_player!.isPlaying ? Icons.stop : Icons.play_arrow),
                color: _player!.isPlaying ? Colors.grey : Colors.blue,
                onPressed: _getPlayback),
            Text(_player!.isPlaying ? '재생 중입니다' : '버튼을 누르시면 재생됩니다')
          ],
        )
      ],
    );
  }
}
