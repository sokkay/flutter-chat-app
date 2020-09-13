part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserUpdateInfo extends UserEvent {
  final Usuario user;

  UserUpdateInfo(this.user);

  @override
  List<Object> get props => [user];
}
