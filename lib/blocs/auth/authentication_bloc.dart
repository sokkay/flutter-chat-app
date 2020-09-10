import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/services/auth_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:chat/models/usuario.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final authService = AuthService();

  AuthenticationBloc() : super(const AuthenticationState.unknown());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStatusChanged) {
      yield* mapLoginToState(event.status);
    }
    if (event is AuthenticationLogoutRequested) {
      yield* mapLogoutTotState();
    }
  }

  Stream<AuthenticationState> mapLoginToState(
      AuthenticationStatus status) async* {
    switch (status) {
      case AuthenticationStatus.authenticated:
        if (await authService.isLoggedIn()) {
          yield AuthenticationState.authenticated(authService.usuario);
        } else {
          yield const AuthenticationState.unauthenticated();
        }
        break;
      case AuthenticationStatus.unauthenticated:
        yield const AuthenticationState.unauthenticated();
        break;
      default:
        yield const AuthenticationState.unknown();
        break;
    }
  }

  Stream<AuthenticationState> mapLogoutTotState() async* {
    try {
      await authService.logout();
      add(AuthenticationStatusChanged(AuthenticationStatus.unauthenticated));
    } catch (e) {
      add(AuthenticationStatusChanged(AuthenticationStatus.unknown));
    }
  }
}
