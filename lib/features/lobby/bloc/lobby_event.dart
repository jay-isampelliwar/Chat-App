part of 'lobby_bloc.dart';

abstract class LobbyEvent extends Equatable {
  const LobbyEvent();

  @override
  List<Object> get props => [];
}

class LobbyChatNavigatorActionEvent extends LobbyEvent {
  String name;

  LobbyChatNavigatorActionEvent({
    required this.name,
  });

  @override
  List<Object> get props => [name];
}
