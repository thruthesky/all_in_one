import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:connection/connection.dart';

class BetaScreen extends StatelessWidget {
  const BetaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Container(
        child: Column(
          children: [
            ConnectionDisplay(),
          ],
        ),
      ),
    );
  }
}
