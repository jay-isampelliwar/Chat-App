import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'lobby_event.dart';
part 'lobby_state.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  LobbyBloc() : super(LobbyInitial()) {
    on<LobbyChatNavigatorActionEvent>(lobbyChatNavigatorActionEvent);
  }

  FutureOr<void> lobbyChatNavigatorActionEvent(
      LobbyChatNavigatorActionEvent event, Emitter<LobbyState> emit) {
    emit(LobbyChatNavigatorActionState(phone: event.phone, name: event.name));
  }
}
