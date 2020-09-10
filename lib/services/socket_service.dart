import 'dart:async';

import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

@Deprecated("Usar Bloc")
class SocketService {
  IO.Socket _socket;

  Function get emit => this._socket.emit;

  StreamController _socketCtrl = new StreamController();

  Stream get socketStream => _socketCtrl.stream;

  Future<IO.Socket> connect() async {
    final token = await AuthService.getToken();

    // Dart client
    this._socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    this._socket.on('connect', (_) => print('Conectado'));

    this._socket.on('disconnect', (_) => print('Desconectado'));
    return this._socket;
  }

  void disconnect() {
    this._socket.disconnect();
    this._socketCtrl.close();
  }
}
