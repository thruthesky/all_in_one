import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_recorder/voice_recorder.dart';

class VoiceRecorderPlayerScreen extends StatefulWidget {
  const VoiceRecorderPlayerScreen({Key? key}) : super(key: key);

  @override
  _VoiceRecorderPlayerScreenState createState() => _VoiceRecorderPlayerScreenState();
}

class _VoiceRecorderPlayerScreenState extends State<VoiceRecorderPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Layout(title: '녹음 파일 재생', body: VoiceRecorderPlayerDisplay(Get.arguments['file']));
  }
}
