import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import "package:socket_io_client/socket_io_client.dart" as IO;
import 'package:socket_io_test/features/chat/model/message_model.dart';
import 'package:socket_io_test/messages.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final IO.Socket _socket = IO.io("http://192.168.1.10:3000",
      IO.OptionBuilder().setTransports(['websocket']).build());
  ChatBloc() : super(ChatInitial()) {
    on<ChatSendMessageEvent>(chatSendMessageEvent);
    on<ChatUpdateEvent>(chatUpdateEvent);
    on<ChatNewUserJoinEvent>(chatNewUserJoinEvent);
  }

  FutureOr<void> chatSendMessageEvent(
      ChatSendMessageEvent event, Emitter<ChatState> emit) {
    Message message = event.message;
    _socket.emit("message", {
      "message": message.message,
      "username": message.username,
      "date": message.date.toString(),
    });
  }

  FutureOr<void> chatNewUserJoinEvent(
      ChatNewUserJoinEvent event, Emitter<ChatState> emit) {
    _socket.emit("newUserJoin", {"username": event.name, "phone": event.phone});
    emit(ChatUpdateState());
  }

  FutureOr<void> chatUpdateEvent(
      ChatUpdateEvent event, Emitter<ChatState> emit) {
    Message? message;
    log(event.map.toString());
    if (event.map["isJoin"]) {
      message = Message(
        message: "",
        date: DateTime.now(),
        join: true,
        username: event.map["data"]["username"],
      );
    } else {
      message = Message(
          message: event.map["data"]["message"],
          date: DateTime.parse(event.map["data"]["date"]),
          username: event.map["data"]["username"]);
    }
    messages.add(message);
    emit(ChatUpdateState());
  }
}
