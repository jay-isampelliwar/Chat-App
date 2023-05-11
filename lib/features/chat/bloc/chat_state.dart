part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatActionState extends ChatState {}

class ChatInitial extends ChatState {}

class ChatUpdateState extends ChatState {
  @override
  List<Object> get props => [];
}
