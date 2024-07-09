import 'package:flutter/material.dart';

class SimpleHomeScreen extends StatefulWidget {
  static const String routeName = '/';
  const SimpleHomeScreen({super.key});

  @override
  State<SimpleHomeScreen> createState() => _SimpleHomeScreenState();
}

class _SimpleHomeScreenState extends State<SimpleHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SimpleHome'),
      ),
      body: const Column(
        children: [
          Text("SimpleHome"),
        ],
      ),
    );
  }
}
