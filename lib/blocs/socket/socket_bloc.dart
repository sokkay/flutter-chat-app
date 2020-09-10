import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  SocketBloc() : super(const SocketState());

  @override
  Stream<SocketState> mapEventToState(
    SocketEvent event,
  ) async* {
    if (event is SocketConnect) {
      yield* mapConnecttoState();
    }
    if (event is SocketDisconnect) {
      yield* mapDisconnecttoState();
    }
    if (event is _SocketStatusChange) {
      yield* mapStatusChangeToState(event.serverStatus);
    }
  }

  Stream<SocketState> mapConnecttoState() async* {
    try {
      final socket = await _connect();
      yield state.copyWith(
        socket: socket,
      );
    } catch (e, stack) {
      print(e);
      print(stack);
      yield state.copyWith(serverStatus: ServerStatus.Offline);
    }
  }

  Stream<SocketState> mapDisconnecttoState() async* {
    _disconnect();
    yield state.copyWith(socket: null, serverStatus: ServerStatus.Offline);
  }

  Stream<SocketState> mapStatusChangeToState(ServerStatus serverStatus) async* {
    print(serverStatus);
    yield state.copyWith(serverStatus: serverStatus);
  }

  Future<IO.Socket> _connect() async {
    final token = await AuthService.getToken();
    IO.Socket socket;
    // Dart client
    socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    socket.on('connect', (_) {
      print('Conectado');
      this.add(_SocketStatusChange(ServerStatus.Online));
    });

    socket.on('disconnect', (_) {
      print('Desconectado');
      this.add(_SocketStatusChange(ServerStatus.Offline));
    });
    return socket;
  }

  void _disconnect() {
    state.socket?.disconnect();
  }
}
