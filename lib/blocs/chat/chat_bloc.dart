import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/services/chat_service.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService = new ChatService();
  ChatBloc() : super(ChatState());

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ChatGetAll) {
      yield* _mapGetAllToState(event.userTo);
    }
  }

  Stream<ChatState> _mapGetAllToState(Usuario userTo) async* {
    yield state.copyWith(chatStatus: ChatStatus.loading, userTo: userTo);
    try {
      final messages = await _chatService.getChat(userTo.uid);
      yield state.copyWith(chatStatus: ChatStatus.complete, messages: messages);
    } catch (e) {
      yield state.copyWith(chatStatus: ChatStatus.error);
    }
  }
}
