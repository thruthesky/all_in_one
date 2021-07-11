import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:voice_recorder/voice_recorder.dart';

class VoiceRecorderScreen extends StatefulWidget {
  const VoiceRecorderScreen({Key? key}) : super(key: key);

  @override
  _VoiceRecorderScreenState createState() => _VoiceRecorderScreenState();
}

class _VoiceRecorderScreenState extends State<VoiceRecorderScreen> {
  @override
  Widget build(BuildContext context) {
    return Layout(body: VoiceRecorderDisplay());
  }
}
