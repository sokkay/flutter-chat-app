import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/models/form_models/email.dart';
import 'package:chat/models/form_models/name.dart';
import 'package:chat/models/form_models/password.dart';
import 'package:chat/services/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService _authService = new AuthService();
  RegisterBloc() : super(const RegisterState());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapEmailChangedToState(event);
    }
    if (event is RegisterPasswordChanged) {
      yield* _mapPasswordChangedToState(event);
    }
    if (event is RegisterNameChanged) {
      yield* _mapNameChangedToState(event);
    }
    if (event is RegisterSubmitted) {
      yield* _mapSubmittedToState();
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(
      RegisterEmailChanged event) async* {
    final email = Email.dirty(event.email);
    yield state.copyWith(
        email: email,
        status: Formz.validate([email, state.password, state.name]));
  }

  Stream<RegisterState> _mapPasswordChangedToState(
      RegisterPasswordChanged event) async* {
    final password = Password.dirty(event.password);
    yield state.copyWith(
        password: password,
        status: Formz.validate([state.email, password, state.name]));
  }

  Stream<RegisterState> _mapNameChangedToState(
      RegisterNameChanged event) async* {
    final name = Name.dirty(event.name);
    yield state.copyWith(
        name: name,
        status: Formz.validate([state.email, state.password, name]));
  }

  Stream<RegisterState> _mapSubmittedToState() async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    if (state.status.isValidated) {
      try {
        final error = await _authService.register(
          state.name.value,
          state.email.value,
          state.password.value,
        );
        if (error != null) {
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
            errorMessage: error,
          );
        }
        yield state.copyWith(
          status: FormzStatus.submissionSuccess
        );
      } catch (e) {
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: "Intentelo mas tarde",
        );
      }
    } else {
      yield state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: 'Todos los campos deben ser válidos');
    }
  }
}
