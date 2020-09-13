part of 'friends_bloc.dart';

enum FriendsStatus { initial, loading, complete, error }

class FriendsState extends Equatable {
  final List<Usuario> friends;
  final FriendsStatus friendsStatus;
  final String errorMessage;

  const FriendsState({
    this.friends = const [],
    this.friendsStatus = FriendsStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object> get props => [friends, friendsStatus, errorMessage];

  FriendsState copyWith({
    List<Usuario> friends,
    FriendsStatus friendsStatus,
    String errorMessage,
  }) {
    return FriendsState(
      friends: friends ?? this.friends,
      friendsStatus: friendsStatus ?? this.friendsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
