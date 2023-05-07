part of 'lobby_bloc.dart';

abstract class LobbyEvent extends Equatable {
  const LobbyEvent();

  @override
  List<Object> get props => [];
}

class LobbyChatNavigatorActionEvent extends LobbyEvent {
  String name;
  String phone;
  LobbyChatNavigatorActionEvent({
    required this.name,
    required this.phone,
  });

  @override
  List<Object> get props => [name, phone];
}
