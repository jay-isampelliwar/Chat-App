import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  Chat({required this.name, required this.phone, super.key});
  String name;
  String phone;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(),
      ),
    );
  }
}
