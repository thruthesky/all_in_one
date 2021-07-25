import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:widgets/widgets.dart';

class VoiceRecorderPlayerDisplay extends StatefulWidget {
  final _file;
  const VoiceRecorderPlayerDisplay(this._file, {Key? key}) : super(key: key);

  @override
  _VoiceRecorderPlayerDisplayState createState() => _VoiceRecorderPlayerDisplayState();
}

class _VoiceRecorderPlayerDisplayState extends State<VoiceRecorderPlayerDisplay> {
  late Track track;

  @override
  void initState() {
    super.initState();

    track = Track(trackPath: widget._file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        spaceLg,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: md),
          child: SoundPlayerUI.fromTrack(track),
        )
      ],
    );
  }
}
