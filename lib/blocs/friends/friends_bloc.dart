import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/services/friends_service.dart';
import 'package:equatable/equatable.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final FriendsService _friendsService = new FriendsService();
  FriendsBloc() : super(const FriendsState());

  @override
  Stream<FriendsState> mapEventToState(
    FriendsEvent event,
  ) async* {
    if (event is FriendsInitialLoad) {
      yield* _mapInitialLoadToState(event.friends);
    }
    if (event is FriendsGetAll) {
      yield* _mapGetAllToState();
    }
    if (event is FriendsAddOne) {
      yield* _mapFriendsAddOneToState(event.email);
    }
  }

  Stream<FriendsState> _mapInitialLoadToState(List<Usuario> friends) async* {
    yield state.copyWith(
        friends: friends, friendsStatus: FriendsStatus.complete);
  }

  Stream<FriendsState> _mapGetAllToState() async* {}

  Stream<FriendsState> _mapFriendsAddOneToState(String email) async* {
    yield state.copyWith(friendsStatus: FriendsStatus.loading);
    try {
      final friend = await _friendsService.addFriend(email);

      yield state.copyWith(
        friends: [...state.friends, friend],
        friendsStatus: FriendsStatus.complete,
      );
    } catch (e) {
      yield state.copyWith(
        friendsStatus: FriendsStatus.error,
        errorMessage: "Error inesperado intente mas tarde",
      );
    }
  }
}
