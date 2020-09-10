part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatGetAll extends ChatEvent {
  final Usuario userTo;

  ChatGetAll(this.userTo);

  @override
  List<Object> get props => [userTo];
}
