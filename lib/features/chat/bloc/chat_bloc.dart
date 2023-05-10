import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import "package:socket_io_client/socket_io_client.dart" as IO;
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final IO.Socket _socket = IO.io("http://localhost/3000",
      IO.OptionBuilder().setTransports(['websocket']).build());
  ChatBloc() : super(ChatInitial()) {
    on<InitialChatSocketIOConnectionEvent>(initialChatSocketIOConnectionEvent);
  }

  FutureOr<void> initialChatSocketIOConnectionEvent(
      InitialChatSocketIOConnectionEvent event, Emitter<ChatState> emit) {
    _socket.onConnect((data) {
      log("Connected io Socket");
    });

    _socket.onConnectError((data) {
      log("Error in Socket");
    });
    _socket.onDisconnect((data) {
      log("Disconnect to Socket");
    });
  }
}
