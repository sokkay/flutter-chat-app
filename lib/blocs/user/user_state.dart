part of 'user_bloc.dart';

enum UserStatus { initial, loading, complete, error }

class UserState extends Equatable {
  final Usuario user;
  final UserStatus userStatus;
  final String errorMessage;

  const UserState({
    this.user,
    this.userStatus = UserStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object> get props => [user, userStatus, errorMessage];

  UserState copyWith({
    Usuario user,
    UserStatus userStatus,
    String errorMessage,
  }) {
    return UserState(
      user: user ?? this.user,
      userStatus: userStatus ?? this.userStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
