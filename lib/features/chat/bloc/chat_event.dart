part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class InitialChatSocketIOConnectionEvent extends ChatEvent {}

class ChatUpdateEvent extends ChatEvent {
  Map<String, dynamic> map;
  ChatUpdateEvent({
    required this.map,
  });
  @override
  List<Object> get props => [map];
}

class ChatSendMessageEvent extends ChatEvent {
  Message message;
  ChatSendMessageEvent({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ChatNewUserJoinEvent extends ChatEvent {
  String name;
  String phone;
  ChatNewUserJoinEvent({
    required this.name,
    required this.phone,
  });
  @override
  List<Object> get props => [name, phone];
}
