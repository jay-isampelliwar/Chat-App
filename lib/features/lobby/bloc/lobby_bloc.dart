import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'lobby_event.dart';
part 'lobby_state.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  LobbyBloc() : super(LobbyInitial()) {
    on<LobbyEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
