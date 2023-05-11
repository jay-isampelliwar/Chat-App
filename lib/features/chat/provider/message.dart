import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../model/message_model.dart';

class MessageProvider extends ChangeNotifier {
  final List<Message> _messages = [];
  int numberOfActiveUser = 0;
  List<Message> get messages => _messages;

  void addMessage(Map<String, dynamic> map) {
    log(map.toString());
    Message? newMessage;
    if (map["isJoin"]) {
      newMessage = Message(
        message: "",
        date: DateTime.now(),
        join: true,
        username: map["data"]["username"],
      );
    } else {
      newMessage = Message(
          message: map["data"]["message"],
          date: DateTime.parse(map["data"]["date"]),
          username: map["data"]["username"]);
    }
    _messages.add(newMessage);
    notifyListeners();
  }

  void disconnectUser() {
    notifyListeners();
  }
}
