import 'package:flutter/material.dart';
import 'package:socket_io_test/features/chat/ui/chat.dart';
import 'package:socket_io_test/locator.dart';

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey),
      // home: Lobby(),
      home: Chat(
        name: 'Jay',
        phone: "7030356059",
      ),
    );
  }
}
