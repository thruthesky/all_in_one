import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';

class YoutubeScreen extends StatelessWidget {
  const YoutubeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Youtube',
      body: Column(
        children: [
          Text('Youtube 페이지'),
        ],
      ),
    );
  }
}
