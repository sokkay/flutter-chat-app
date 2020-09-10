part of 'socket_bloc.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketState extends Equatable {
  final ServerStatus serverStatus;
  final IO.Socket socket;

  const SocketState({
    this.serverStatus = ServerStatus.Connecting,
    this.socket,
  });

  @override
  List<Object> get props => [serverStatus,socket];

  SocketState copyWith({
    ServerStatus serverStatus,
    IO.Socket socket,
  }) {
    return SocketState(
      serverStatus: serverStatus ?? this.serverStatus,
      socket: socket ?? this.socket,
    );
  }
}
