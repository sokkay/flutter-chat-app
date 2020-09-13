import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/blocs/auth/authentication_bloc.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/services/user_service.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _userService = new UserService();
  final AuthenticationBloc authBloc;

  UserBloc(this.authBloc) : super(const UserState());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserUpdateInfo) {
      yield* _mapUpdateToState(event.user);
    }
  }

  Stream<UserState> _mapUpdateToState(Usuario user) async* {
    yield state.copyWith(userStatus: UserStatus.loading);
    try {
      final resp = await _userService.updateUserInfo(user);
      yield state.copyWith(user: resp, userStatus: UserStatus.complete);
      authBloc.add(AuthenticationUserChanged());
    } catch (e) {
      yield state.copyWith(
        userStatus: UserStatus.error,
        errorMessage: "Intentelo mas tarde",
      );
    }
  }
}
