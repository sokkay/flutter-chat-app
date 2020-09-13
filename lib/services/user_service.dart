import 'dart:convert';
import 'dart:io';

import 'package:chat/global/environment.dart';
import 'package:chat/models/usuario.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class UserService {
  static UserService _instance;
  final AuthService _authService = new AuthService();

  factory UserService() {
    if (_instance == null) {
      _instance = new UserService._();
    }
    return _instance;
  }

  UserService._();

  Future<Usuario> updateUserInfo(Usuario user) async {
    try {
      final resp = await http.put(
        '${Environment.apiUrl}/usuarios/info',
        headers: {
          'x-token': await AuthService.getToken(),
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: user.toJson(),
      );
      final userResponse = Usuario.fromMap(jsonDecode(resp.body)['usuario']);
      _authService.usuario = userResponse;
      return userResponse;
    } catch (e, stack) {
      print(e);
      print(stack);
      return null;
    }
  }
}
