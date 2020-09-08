import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final resp = await http.get(
        '${Environment.apiUrl}/usuarios',
        headers: {'x-token': await AuthService.getToken()},
      );
      final usuarios = (jsonDecode(resp.body)['usuarios'] as List)
          .map((e) => Usuario.fromMap(e))
          .toList();
      return usuarios;
    } catch (e) {
      print(e);
    }
  }
}
