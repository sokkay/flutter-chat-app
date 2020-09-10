part of 'chat_bloc.dart';

enum ChatStatus { empty, loading, complete, initial, error }

class ChatState extends Equatable {
  final ChatStatus chatStatus;
  final Usuario userTo;
  final List<Message> messages;

  const ChatState({
    this.chatStatus = ChatStatus.initial,
    this.messages,
    this.userTo,
  });

  @override
  List<Object> get props => [chatStatus, messages, userTo];

  ChatState copyWith({
    ChatStatus chatStatus,
    Usuario userTo,
    List<Message> messages,
  }) {
    return ChatState(
      chatStatus: chatStatus ?? this.chatStatus,
      userTo: userTo ?? this.userTo,
      messages: messages ?? this.messages,
    );
  }
}
