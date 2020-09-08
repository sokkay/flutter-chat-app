import 'package:chat/global/environment.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/mensaje_response.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  Usuario usuarioTo;

  Future<List<Message>> getChat(String usuarioID) async {
    try {
      final resp = await http.get(
        '${Environment.apiUrl}/mensajes/$usuarioID',
        headers: {'x-token': await AuthService.getToken()},
      );
      final messagesResponse = MensajesResponse.fromJson(resp.body);
      return messagesResponse.messages;
    } catch (e) {
      print(e);
    }
  }
}
