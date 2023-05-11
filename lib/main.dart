import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_test/features/chat/provider/message.dart';
import 'package:socket_io_test/locator.dart';

import 'features/lobby/ui/lobby.dart';

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MessageProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.grey),
        home: Lobby(),
      ),
    );
  }
}
