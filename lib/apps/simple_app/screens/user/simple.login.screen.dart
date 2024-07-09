import 'package:flutter/material.dart';

class SimpleLoginScreen extends StatefulWidget {
  static const String routeName = '/SimpleLogin';
  const SimpleLoginScreen({super.key});

  @override
  State<SimpleLoginScreen> createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<SimpleLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SimpleLogin'),
      ),
      body: const Column(
        children: [
          Text("SimpleLogin"),
        ],
      ),
    );
  }
}
