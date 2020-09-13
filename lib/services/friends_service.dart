import 'dart:convert';
import 'dart:io';

import 'package:chat/global/environment.dart';
import 'package:chat/helpers/handle_error.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class FriendsService {
  static FriendsService _instance;

  factory FriendsService() {
    if (_instance == null) {
      _instance = new FriendsService._();
    }
    return _instance;
  }

  FriendsService._();

  Future<List<Usuario>> getFriends() async {
    try {
      final resp = await http.get(
        '${Environment.apiUrl}/usuarios/friends',
        headers: {'x-token': await AuthService.getToken()},
      );
      final usuarios = (jsonDecode(resp.body)['usuarios'] as List)
          .map((e) => Usuario.fromMap(e))
          .toList();
      return usuarios;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Usuario> addFriend(String email) async {
    try {
      final resp = await http.post(
        '${Environment.apiUrl}/usuarios/friends',
        headers: {
          'x-token': await AuthService.getToken(),
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({"email": email}),
      );
      if (resp.statusCode == 201) {
        return Usuario.fromMap(jsonDecode(resp.body)['usuario']);
      } else {
        return null;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      return null;
    }
  }
}
