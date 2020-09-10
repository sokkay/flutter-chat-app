part of 'socket_bloc.dart';

abstract class SocketEvent extends Equatable {
  const SocketEvent();

  @override
  List<Object> get props => [];
}

class SocketConnect extends SocketEvent {}

class SocketDisconnect extends SocketEvent {}

class _SocketStatusChange extends SocketEvent {
  final ServerStatus serverStatus;

  _SocketStatusChange(this.serverStatus);

  @override
  List<Object> get props => [serverStatus];
}
