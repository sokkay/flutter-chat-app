part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final Email email;
  final Password password;
  final Name name;
  final FormzStatus status;
  final String errorMessage;

  const RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.name = const Name.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  @override
  List<Object> get props => [email, password, name, status, errorMessage];

  RegisterState copyWith({
    Email email,
    Password password,
    Name name,
    FormzStatus status,
    String errorMessage,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      status: status ?? this.status,
      errorMessage: errorMessage ?? null,
    );
  }
}
