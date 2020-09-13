part of 'friends_bloc.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

class FriendsInitialLoad extends FriendsEvent {
  final List<Usuario> friends;

  FriendsInitialLoad(this.friends);

  @override
  List<Object> get props => [friends];
}

class FriendsGetAll extends FriendsEvent {}

class FriendsAddOne extends FriendsEvent {
  final String email;

  FriendsAddOne(this.email);

  @override
  List<Object> get props => [email];
}
